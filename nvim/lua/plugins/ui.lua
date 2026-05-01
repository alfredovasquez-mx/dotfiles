return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = false,
      transparent = true,
      theme = "dragon",
      background = {
        dark = "dragon",
        light = "lotus",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-dragon",
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git" },
        {
          "<leader>o",
          group = "obsidian",
          icon = { icon = "󰎚 ", color = "purple" },
        },
        { "<leader>t", group = "test" },
        { "<leader>F", group = "flutter" },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "kanagawa"
    end,
  },
}
