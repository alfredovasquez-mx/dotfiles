return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      "nvim-mini/mini.icons",
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Oil" },
      {
        "<leader>-",
        function()
          require("oil").open_float()
        end,
        desc = "Oil (float)",
      },
    },
    opts = {
      default_file_explorer = true,
      columns = {
        "icon",
      },
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["q"] = "actions.close",
        ["<Esc>"] = "actions.close",
      },
      view_options = {
        show_hidden = false,
        natural_order = true,
      },
      float = {
        padding = 2,
        max_width = 0.72,
        max_height = 0.72,
        border = "rounded",
      },
    },
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*",
    ft = { "markdown" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      return {
        workspaces = {
          {
            name = "brain",
            path = vim.fn.expand("~/brain"),
          },
        },
        notes_subdir = "00 Inbox",
        new_notes_location = "notes_subdir",
        preferred_link_style = "wiki",
        completion = {
          nvim_cmp = false,
          min_chars = 2,
        },
        daily_notes = {
          folder = "01 Daily",
          date_format = "%Y-%m-%d",
          template = "06 Templates/Daily Note.md",
        },
        templates = {
          folder = "06 Templates",
          date_format = "%Y-%m-%d",
          time_format = "%H:%M",
        },
        attachments = {
          img_folder = "05 Assets",
          img_name_func = function()
            return string.format("%s-", os.time())
          end,
        },
        ui = {
          enable = false,
        },
      }
    end,
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note" },
      { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Today" },
      { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search" },
      { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Template" },
      { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste Image" },
      { "<leader>ow", "<cmd>ObsidianWorkspace brain<cr>", desc = "Workspace" },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {
      file_types = { "markdown" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      checkbox = {
        enabled = true,
      },
      bullet = {
        icons = { "●", "○", "◆", "◇" },
      },
    },
  },

  {
    "3rd/image.nvim",
    ft = { "markdown" },
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = true,
      window_overlap_clear_enabled = true,
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          floating_windows = false,
          filetypes = { "markdown" },
        },
      },
      max_width_window_percentage = 50,
      max_height_window_percentage = 50,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_theme = "dark"
    end,
  },
}
