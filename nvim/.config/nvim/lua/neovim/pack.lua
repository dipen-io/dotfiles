vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.pack.add({
  -- treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

  -- snacks
  { src = "https://github.com/folke/snacks.nvim" },

  -- blink + its dependencies
  -- { src = "https://github.com/saghen/blink.cmp", version = "v1" },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') },


  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/folke/lazydev.nvim" },

  -- mason
  { src = "https://github.com/williamboman/mason.nvim" },
  { src = "https://github.com/williamboman/mason-lspconfig.nvim" },

  -- flutter
  { src = "https://github.com/nvim-flutter/flutter-tools.nvim" },

  -- render preview (markdown?)
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },

  -- oil 
  { src = "https://github.com/stevearc/oil.nvim" },
  -- colorsheme
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/ember-theme/nvim" }

})

require("neovim.plugins.blink")
require("neovim.plugins.snacks")
require("neovim.plugins.mason")
require("neovim.plugins.treesitter")
require("neovim.plugins.oil")
require("neovim.plugins.color")
