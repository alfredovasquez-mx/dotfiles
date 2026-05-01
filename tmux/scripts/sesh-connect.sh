#!/usr/bin/env python3
import os
import re
import shlex
import subprocess
import sys
import time
from pathlib import Path

CONFIG_FILE = Path("/Users/alfredo.vasquez/.config/sesh/sesh.toml")
TMUX_BIN = "/opt/homebrew/bin/tmux"
SESH_BIN = "/opt/homebrew/bin/sesh"
FISH_BIN = "/opt/homebrew/bin/fish"
RENAME_SCRIPT = "/Users/alfredo.vasquez/.config/tmux/scripts/rename-current-window.sh"
BOOTSTRAP_FLAG = "@codex_sesh_bootstrap_done"
WINDOW_CMD_OPT = "@codex_sesh_cmd"
WINDOW_STATE_OPT = "@codex_sesh_state"
PRELOAD_WINDOWS = {"ai"}
BACKGROUND_WINDOWS = {"git", "editor", "sql", "http"}
LATE_BACKGROUND_WINDOWS = {"http"}
PRELOAD_DELAY = {
    "ai": 0.55,
}
BACKGROUND_DELAY = {
    "git": 1.0,
    "editor": 1.6,
    "sql": 2.2,
    "http": 3.6,
}


def run(*args, check=True, capture=False):
    kwargs = {"check": check, "text": True}
    if capture:
        kwargs["capture_output"] = True
    return subprocess.run(args, **kwargs)


def strip_target(raw: str) -> str:
    raw = raw.strip()
    raw = re.sub(r"\x1b\[[0-9;]*[A-Za-z]", "", raw)
    raw = re.sub(r"^\S+\s+", "", raw)
    return raw.strip()


def parse_value(raw: str):
    raw = raw.strip()
    if raw.startswith("[") and raw.endswith("]"):
        inner = raw[1:-1].strip()
        if not inner:
            return []
        return re.findall(r'"([^"]*)"', inner)
    if raw.startswith('"') and raw.endswith('"'):
        return raw[1:-1]
    if raw.lower() == "true":
        return True
    if raw.lower() == "false":
        return False
    return raw


def parse_config(path: Path):
    text = path.read_text()
    state = None
    current = None
    sessions = []
    windows = []

    def flush():
        nonlocal current, state
        if current is None:
            return
        if state == "session":
            sessions.append(current)
        elif state == "window":
            windows.append(current)
        current = None

    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if line == "[default_session]":
            flush()
            state = "default"
            current = {}
            continue
        if line == "[[session]]":
            flush()
            state = "session"
            current = {}
            continue
        if line == "[[window]]":
            flush()
            state = "window"
            current = {}
            continue
        if "=" in line and current is not None:
            key, value = line.split("=", 1)
            current[key.strip()] = parse_value(value)

    flush()
    return sessions, windows


def resolve_session(target: str):
    sessions, windows = parse_config(CONFIG_FILE)
    session = next((s for s in sessions if s.get("name") == target), None)
    if not session:
        return None

    window_map = {w.get("name"): w for w in windows if w.get("name")}
    resolved_windows = []
    for name in session.get("windows", []):
        win = dict(window_map.get(name, {}))
        if not win:
            continue
        resolved_windows.append(
            {
                "name": name,
                "path": win.get("path") or session.get("path", ""),
                "startup_script": win.get("startup_script", ""),
            }
        )

    return {
        "name": session.get("name", ""),
        "path": session.get("path", ""),
        "windows": resolved_windows,
    }


def has_session(target: str) -> bool:
    return (
        subprocess.run(
            [TMUX_BIN, "has-session", "-t", target],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ).returncode
        == 0
    )


def switch_or_attach(target: str):
    if os.getenv("SESH_CONNECT_NO_ATTACH") == "1":
        return
    if os.getenv("TMUX"):
        os.execv(TMUX_BIN, [TMUX_BIN, "switch-client", "-t", target])
    else:
        os.execv(TMUX_BIN, [TMUX_BIN, "attach-session", "-t", target])


def session_flag(target: str) -> str:
    proc = run(
        TMUX_BIN,
        "show-options",
        "-t",
        target,
        "-v",
        BOOTSTRAP_FLAG,
        check=False,
        capture=True,
    )
    return (proc.stdout or "").strip()


def set_session_flag(target: str, value: str):
    run(TMUX_BIN, "set-option", "-t", target, BOOTSTRAP_FLAG, value)


def list_windows(target: str):
    proc = run(
        TMUX_BIN,
        "list-windows",
        "-t",
        target,
        "-F",
        "#{window_index}\t#{window_name}",
        capture=True,
    )
    result = {}
    for line in (proc.stdout or "").splitlines():
        if "\t" not in line:
            continue
        idx, name = line.split("\t", 1)
        result[name] = idx
    return result


def set_window_option(target: str, index: str, option: str, value: str):
    run(TMUX_BIN, "set-window-option", "-t", f"{target}:{index}", option, value)


def get_window_option(target: str, index: str, option: str) -> str:
    proc = run(
        TMUX_BIN,
        "show-window-options",
        "-t",
        f"{target}:{index}",
        "-v",
        option,
        check=False,
        capture=True,
    )
    return (proc.stdout or "").strip()


def startup_delay(name: str) -> float:
    if name in PRELOAD_WINDOWS:
        return PRELOAD_DELAY.get(name, 0.0)
    return BACKGROUND_DELAY.get(name, 0.0)


def build_window_shell_command(name: str, startup_script: str) -> str:
    if not startup_script:
        return ""

    delay = startup_delay(name)
    fish_inner_parts = []
    if delay > 0:
        fish_inner_parts.append(f"sleep {delay}")
    fish_inner_parts.append(
        f'{shlex.quote(TMUX_BIN)} set-window-option {shlex.quote(WINDOW_STATE_OPT)} starting >/dev/null 2>&1 || true'
    )
    fish_inner_parts.append(
        f'{shlex.quote(RENAME_SCRIPT)} {shlex.quote(startup_script)} "$PWD" >/dev/null 2>&1 || true'
    )
    fish_inner_parts.append(
        f'{shlex.quote(TMUX_BIN)} set-window-option {shlex.quote(WINDOW_STATE_OPT)} done >/dev/null 2>&1 || true'
    )
    fish_inner_parts.append(
        f'{shlex.quote(TMUX_BIN)} refresh-client -S >/dev/null 2>&1 || true'
    )
    fish_inner_parts.append(startup_script)
    fish_inner_parts.append(f"exec {shlex.quote(FISH_BIN)} -il")
    fish_inner = "; ".join(fish_inner_parts)
    return f'{shlex.quote(FISH_BIN)} -lc {shlex.quote(fish_inner)}'


def wake_and_run(pane_target: str, command: str, enter_delay: float = 0.45, command_delay: float = 0.6):
    time.sleep(enter_delay)
    run(TMUX_BIN, "send-keys", "-t", pane_target, "Enter")
    time.sleep(command_delay)
    if command:
        run(TMUX_BIN, "send-keys", "-t", pane_target, command, "Enter")


def spawn_window_start(target: str, index: str, delay: float = 0.0):
    subprocess.Popen(
        [sys.executable, __file__, "--start-window", target, str(index), str(delay)],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=True,
    )


def start_window(target: str, index: str, delay: float = 0.0):
    if delay > 0:
        time.sleep(delay)

    if not has_session(target):
        return 0

    lock_name = f"codex-sesh-start-{target}-{index}"
    run(TMUX_BIN, "wait-for", "-L", lock_name)
    try:
        state = get_window_option(target, index, WINDOW_STATE_OPT)
        if state not in {"pending-preload", "pending-bg", "pending-late", "pending-lazy"}:
            return 0

        command = get_window_option(target, index, WINDOW_CMD_OPT)
        if not command:
            set_window_option(target, index, WINDOW_STATE_OPT, "done")
            return 0

        set_window_option(target, index, WINDOW_STATE_OPT, "starting")
        wake_and_run(f"{target}:{index}.1", command)
        set_window_option(target, index, WINDOW_STATE_OPT, "done")
    finally:
        run(TMUX_BIN, "wait-for", "-U", lock_name)

    return 0


def start_current_window():
    if not os.getenv("TMUX"):
        return 0
    target = run(TMUX_BIN, "display-message", "-p", "#{session_name}", capture=True).stdout.strip()
    index = run(TMUX_BIN, "display-message", "-p", "#{window_index}", capture=True).stdout.strip()
    if not target or not index:
        return 0
    return start_window(target, index)


def bootstrap_session(target: str):
    if not has_session(target):
        return 0
    if session_flag(target) == "1":
        return 0

    session = resolve_session(target)
    if not session:
        return 0

    windows = session.get("windows", [])
    if not windows:
        set_session_flag(target, "1")
        return 0

    time.sleep(0.2)
    for idx, win in enumerate(windows, start=1):
        command = win.get("startup_script", "")
        if idx == 1:
            window_index = "1"
        else:
            proc_args = [
                TMUX_BIN,
                "new-window",
                "-d",
                "-P",
                "-F",
                "#{window_index}",
                "-t",
                f"{target}:",
                "-n",
                win["name"],
                "-c",
                win["path"],
            ]
            if command:
                proc_args.append(build_window_shell_command(win["name"], command))
            proc = run(*proc_args, capture=True)
            window_index = proc.stdout.strip()

        if not command:
            state = "done"
        elif win["name"] in PRELOAD_WINDOWS:
            state = "pending-preload"
        elif win["name"] in LATE_BACKGROUND_WINDOWS:
            state = "pending-late"
        elif win["name"] in BACKGROUND_WINDOWS:
            state = "pending-bg"
        else:
            state = "pending-lazy"

        set_window_option(target, window_index, WINDOW_CMD_OPT, command)
        set_window_option(target, window_index, WINDOW_STATE_OPT, state)
    set_session_flag(target, "1")
    return 0


def spawn_bootstrap(target: str):
    subprocess.Popen(
        [sys.executable, __file__, "--bootstrap", target],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=True,
    )


def main():
    args = sys.argv[1:]
    if not args:
        return 0

    if args[0] == "--start-window":
        if len(args) < 3:
            return 1
        delay = float(args[3]) if len(args) > 3 else 0.0
        return start_window(args[1], args[2], delay)

    if args[0] == "--start-current-window":
        return start_current_window()

    if args[0] == "--bootstrap":
        if len(args) < 2 or not args[1]:
            return 1
        return bootstrap_session(args[1])

    if args[0] == "--root":
        if len(args) < 2 or not args[1]:
            return 1
        os.execv(SESH_BIN, [SESH_BIN, "connect", "--root", args[1]])

    target = strip_target(args[0])
    if not target:
        return 1

    if has_session(target):
        switch_or_attach(target)
        return 0

    session = resolve_session(target)
    if not session or not session.get("path"):
        os.execv(SESH_BIN, [SESH_BIN, "connect", target])

    first_window = session.get("windows", [{}])[0] if session.get("windows") else None
    if first_window and first_window.get("name"):
        first_command = first_window.get("startup_script", "")
        new_session_args = [
            TMUX_BIN,
            "new-session",
            "-d",
            "-s",
            target,
            "-n",
            first_window["name"],
            "-c",
            first_window.get("path") or session["path"],
        ]
        if first_command:
            new_session_args.append(build_window_shell_command(first_window["name"], first_command))
        run(*new_session_args)
        if first_command:
            first_state = "pending-preload" if first_window["name"] in PRELOAD_WINDOWS else "pending-lazy"
        else:
            first_state = "done"
        set_window_option(target, "1", WINDOW_CMD_OPT, first_command)
        set_window_option(target, "1", WINDOW_STATE_OPT, first_state)
    else:
        run(TMUX_BIN, "new-session", "-d", "-s", target, "-c", session["path"])

    spawn_bootstrap(target)
    switch_or_attach(target)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
