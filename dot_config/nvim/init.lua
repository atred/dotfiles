-- Basics
require("atred.options")
require("atred.keymap")
require("atred.autocmd")

-- Autoinstall plugin manager (lazy.nvim)
require("bootstrap-lazy")

require("lazy").setup({
  -- Basics
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  { "numToStr/Comment.nvim", opts = {} }, -- "gc" to comment visual regions/lines

  require("plugins/theme"),

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = { theme = "kanagawa-dragon" },
  },

  require("plugins/which-key"),
  require("plugins/telescope"),
  require("plugins/lsp"),
  require("plugins/autoformat"),
  require("plugins/completion"),
  require("plugins/mini"),
  require("plugins/treesitter"),
  --require("plugins/autopairs"),
})
