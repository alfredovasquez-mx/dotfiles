local function add_unique(list, items)
  list = list or {}
  for _, item in ipairs(items) do
    if not vim.tbl_contains(list, item) then
      table.insert(list, item)
    end
  end
  return list
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = add_unique(opts.ensure_installed, {
        "bash",
        "css",
        "dart",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        "swift",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      })
    end,
  },
}
