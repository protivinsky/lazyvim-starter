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
}
