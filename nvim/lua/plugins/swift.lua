return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.sourcekit = {
        cmd = vim.fn.executable("xcrun") == 1 and { "xcrun", "sourcekit-lsp" } or { "sourcekit-lsp" },
        filetypes = { "swift" },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.swift = { "swiftformat" }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.swift = { "swiftlint" }
    end,
  },
}
