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
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = add_unique(opts.ensure_installed, {
        "css-lsp",
        "dart-debug-adapter",
        "emmet-language-server",
        "eslint-lsp",
        "gopls",
        "html-lsp",
        "lua-language-server",
        "prettier",
        "pyright",
        "ruff",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "stylua",
        "tailwindcss-language-server",
        "vtsls",
      })
    end,
  },
}
