local function has_flutter()
  return vim.fn.executable("flutter") == 1 and vim.fn.executable("dart") == 1
end

return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = { "dart" },
    enabled = has_flutter,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Flutter Run" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter Devices" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter Emulators" },
      { "<leader>FR", "<cmd>FlutterReload<cr>", desc = "Flutter Reload" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter Quit" },
    },
    config = function()
      require("flutter-tools").setup({
        dev_log = {
          enabled = true,
          open_cmd = "tabedit",
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
        },
        lsp = {
          color = { enabled = true },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if has_flutter() then
        opts.servers = opts.servers or {}
        opts.servers.dartls = { enabled = false }
      end
    end,
  },
}
