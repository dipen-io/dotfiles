-- 1. Plugin Manager Setup
require("neovim.lazy")

-- 2. Load Configurations
-- Note: Order matters! Load settings/keymaps before LSPs usually.
require("neovim.core.settings")
require("neovim.core.keymaps")
require("neovim.core.autocmd")
require("neovim.core.statusline")

-- 3. Load LSP Config
require("neovim.plugins.lsp")


-- 4. Additional setup
vim.filetype.add({
  filename = {
    ['init'] = 'sh',
    ['sxhkdrc'] = 'sxhkdrc',
  },
  pattern = {
    ['.*/river/init'] = 'sh',
  },
})

