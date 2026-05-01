set -l kgw_root "/Users/alfredo.vasquez/dev/shared/kiro-gateway"
set -l kgw_mise_local "$kgw_root/mise.local.toml"

if test -f "$kgw_mise_local"
    set -gx KIRO_GATEWAY_ROOT "$kgw_root"

    set -l proxy_key (python3 -c 'import pathlib,re; text=pathlib.Path("/Users/alfredo.vasquez/dev/shared/kiro-gateway/mise.local.toml").read_text(encoding="utf-8"); match=re.search(r"^PROXY_API_KEY\\s*=\\s*\"([^\"]+)\"", text, re.M); print(match.group(1) if match else "")')

    if test -n "$proxy_key"
        set -gx PROXY_API_KEY "$proxy_key"
    end
end
