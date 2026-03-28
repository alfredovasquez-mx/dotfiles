local glyphs = {
  F = {
    "██████",
    "██    ",
    "█████ ",
    "██    ",
    "██    ",
  },
  L = {
    "██    ",
    "██    ",
    "██    ",
    "██    ",
    "██████",
  },
  O = {
    " ████ ",
    "██  ██",
    "██  ██",
    "██  ██",
    " ████ ",
  },
  W = {
    "██   ██",
    "██   ██",
    "██ █ ██",
    "███████",
    "██   ██",
  },
  C = {
    " █████",
    "██    ",
    "██    ",
    "██    ",
    " █████",
  },
  D = {
    "█████ ",
    "██  ██",
    "██   ██",
    "██  ██",
    "█████ ",
  },
  E = {
    "██████",
    "██    ",
    "█████ ",
    "██    ",
    "██████",
  },
}

local function build_word(word, gap)
  local lines = {}
  for row = 1, #glyphs.F do
    local chars = {}
    for i = 1, #word do
      chars[#chars + 1] = glyphs[word:sub(i, i)][row]
    end
    lines[#lines + 1] = table.concat(chars, gap)
  end
  return lines
end

local function build_header()
  local flow = build_word("FLOW", " ")
  local code = build_word("CODE", " ")
  local lines = {}
  for i = 1, #flow do
    lines[i] = flow[i] .. "    " .. code[i]
  end
  return lines
end

local header_lines = build_header()

local function normalize_header(lines)
  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.api.nvim_strwidth(line))
  end

  for i, line in ipairs(lines) do
    lines[i] = line .. string.rep(" ", width - vim.api.nvim_strwidth(line))
  end

  return table.concat(lines, "\n")
end

local header = normalize_header(header_lines)

local function set_dashboard_highlights()
  local groups = {
    SnacksDashboardNormal = { bg = "none" },
    SnacksDashboardHeader = { fg = "#c4746e", bold = true },
    SnacksDashboardFooter = { fg = "#87a987", italic = true },
    SnacksDashboardDesc = { fg = "#a6a69c" },
    SnacksDashboardIcon = { fg = "#b6927b" },
    SnacksDashboardKey = { fg = "#c4b28a", bold = true },
    SnacksDashboardSpecial = { fg = "#8ea4a2", bold = true },
    SnacksDashboardTitle = { fg = "#b98d7b", bold = true },
    SnacksDashboardDir = { fg = "#737c73" },
    SnacksDashboardFile = { fg = "#8ba4b0" },
  }

  for group, value in pairs(groups) do
    vim.api.nvim_set_hl(0, group, value)
  end
end

return {
  {
    "folke/snacks.nvim",
    init = function()
      local group = vim.api.nvim_create_augroup("custom_snacks_dashboard", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = set_dashboard_highlights,
      })
      set_dashboard_highlights()
    end,
    opts = function(_, opts)
      opts.dashboard = vim.tbl_deep_extend("force", opts.dashboard or {}, {
        width = 72,
        preset = {
          pick = function(cmd, pick_opts)
            return LazyVim.pick(cmd, pick_opts)()
          end,
          header = header,
          keys = {
            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = function()
                Snacks.dashboard.pick("files")
              end,
            },
            {
              icon = " ",
              key = "n",
              desc = "New File",
              action = ":ene | startinsert",
            },
            {
              icon = " ",
              key = "p",
              desc = "Projects",
              action = function()
                Snacks.picker.projects()
              end,
            },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = function()
                Snacks.dashboard.pick("oldfiles")
              end,
            },
            {
              icon = " ",
              key = "s",
              desc = "Restore Session",
              section = "session",
            },
            {
              icon = "󰒲 ",
              key = "l",
              desc = "Lazy",
              action = ":Lazy",
            },
          },
        },
        sections = {
          { section = "header", padding = { 1, 0 } },
          {
            text = {
              { "alfredovasquez-mx", hl = "special", align = "center" },
            },
            padding = { 0, 0 },
          },
          {
            icon = " ",
            title = "Keymaps",
            section = "keys",
            indent = 2,
            padding = { 1, 1 },
          },
          {
            icon = " ",
            title = "Projects",
            section = "projects",
            indent = 2,
            limit = 5,
            padding = { 1, 1 },
          },
          {
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            limit = 4,
            padding = { 1, 1 },
          },
          { section = "startup", icon = "⚡ ", padding = { 1, 0 } },
        },
      })
    end,
  },
}
