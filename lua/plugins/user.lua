local Util = require("lazyvim.util")

return {
  {
    "aserowy/tmux.nvim",
    lazy = false,
    config = function()
      return require("tmux").setup()
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
  },
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require'window-picker'.setup({
        hint = 'floating-big-letter',
      })
    end,
  },
  {
    'stevearc/overseer.nvim',
    opts = {
      strategy = { "toggleterm", direction = "horizontal" },
    },
  },
  -- { "wfxr/minimap.vim" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd(), reveal = true })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>fE",
        function()
          -- vim.api.nvim_set_current_dir(Util.root())
          require("neo-tree.command").execute({ toggle = true, dir = Util.root(), reveal = true })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (cwd)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (root dir)", remap = true },
    --   {
    --     "<leader>E",
    --     function()
    --       require("neo-tree.command").execute({ action = "close" })
    --     end,
    --     desc = "Close NeoTree",
    --   },
    --   {
    --     "<leader>ge",
    --     function()
    --       require("neo-tree.command").execute({ source = "git_status", reveal_force_cwd = true })
    --     end,
    --     desc = "Git explorer",
    --   },
    --   {
    --     "<leader>gE",
    --     function()
    --       require("neo-tree.command").execute({ source = "git_status", toggle = true, reveal_force_cwd = true })
    --     end,
    --     desc = "Toggle git explorer",
    --   },
    --   {
    --     "<leader>be",
    --     function()
    --       require("neo-tree.command").execute({ source = "buffers", reveal_force_cwd = true })
    --     end,
    --     desc = "Buffer explorer",
    --   },
    --   {
    --     "<leader>bE",
    --     function()
    --       require("neo-tree.command").execute({ source = "buffers", toggle = true, reveal_force_cwd = true })
    --     end,
    --     desc = "Toggle buffer explorer",
    --   },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.extensions, "toggleterm")
      opts.options.disabled_filetypes.winbar = { "neo-tree" }

      local winbar_c = {
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { Util.lualine.pretty_path() },
      }
      local winbar_x = {
        opts.sections.lualine_x[#opts.sections.lualine_x],
        opts.sections.lualine_y[1],
        opts.sections.lualine_y[2],
      }

      opts.winbar = {
        lualine_a = opts.sections.lualine_a,
        lualine_b = winbar_c,
        lualine_y = winbar_x,
      }
      -- opts.inactive_winbar = opts.winbar
      opts.inactive_winbar = {
        lualine_a = opts.winbar.lualine_b,
        lualine_y = opts.winbar.lualine_y,
      }

      table.insert(opts.sections.lualine_x, 1, "overseer")
    end,
  },
  { "github/copilot.vim" },
}
