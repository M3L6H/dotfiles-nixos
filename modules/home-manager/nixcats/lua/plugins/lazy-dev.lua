local M = {
  "folke/lazydev.nvim",
  ft = "lua", -- Only load on lua files
  opts = {
    library = {
      "lazy.nvim",
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "snacks.nvim", words = { "Snacks" } },
      { path = "trouble.nvim" },
    },
  },
}

return M
