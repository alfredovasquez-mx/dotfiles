local function transparent_background()
  local groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "EndOfBuffer",
    "FoldColumn",
    "MsgArea",
    "StatusLine",
    "StatusLineNC",
    "WinSeparator",
    "Pmenu",
  }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

local augroup = vim.api.nvim_create_augroup("custom_transparent_bg", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = transparent_background,
})

transparent_background()
