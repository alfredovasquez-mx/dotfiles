local glyphs = {
  F = {
    "111111",
    "110000",
    "111110",
    "110000",
    "110000",
  },
  L = {
    "110000",
    "110000",
    "110000",
    "110000",
    "111111",
  },
  O = {
    "011110",
    "110011",
    "110011",
    "110011",
    "011110",
  },
  W = {
    "11000011",
    "11000011",
    "11011011",
    "11011011",
    "01100110",
  },
  C = {
    "011111",
    "110000",
    "110000",
    "110000",
    "011111",
  },
  D = {
    "111110",
    "110011",
    "110011",
    "110011",
    "111110",
  },
  E = {
    "111111",
    "110000",
    "111110",
    "110000",
    "111111",
  },
}

local digraphs = {
  DE = {
    "1111100111111",
    "1100110110000",
    "1100110111110",
    "1100110110000",
    "1111100111111",
  },
}

local function pixels_to_blocks(rows)
  local rendered = {}
  for i, row in ipairs(rows) do
    rendered[i] = row:gsub("1", "█"):gsub("0", " ")
  end
  return rendered
end

local function build_word(word, opts)
  opts = opts or {}
  local default_gap = opts.gap or 1
  local rows = {}
  local height = #glyphs.F

  local segments = {}
  local i = 1
  while i <= #word do
    local pair = word:sub(i, i + 1)
    if #pair == 2 and digraphs[pair] then
      table.insert(segments, digraphs[pair])
      i = i + 2
    else
      table.insert(segments, glyphs[word:sub(i, i)])
      i = i + 1
    end
  end

  for row = 1, height do
    rows[row] = segments[1][row]
  end

  local gap = string.rep("0", default_gap)
  for segment_index = 2, #segments do
    local segment = segments[segment_index]
    for row = 1, height do
      rows[row] = rows[row] .. gap .. segment[row]
    end
  end

  return rows
end

local function build_header()
  local flow = build_word("FLOW", { gap = 1 })
  local code = build_word("CODE", { gap = 1 })
  local lines = {}
  local word_gap = string.rep("0", 4)

  for i = 1, #flow do
    lines[i] = flow[i] .. word_gap .. code[i]
  end

  return pixels_to_blocks(lines)
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
    SnacksDashboardHeader = { fg = "#c4746e", nocombine = true },
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
