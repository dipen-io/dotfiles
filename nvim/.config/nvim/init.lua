require("neovim.lazy")
-- require("neovim.lsp")
require("neovim.core.keymaps")
require("neovim.core.autocmd")
require("neovim.core.settings")
require("neovim.core.statusline")

vim.filetype.add({
  filename = {
    ['init'] = 'sh',
    ['sxhkdrc'] = 'sxhkdrc',
  },
  pattern = {
    ['.*/river/init'] = 'sh',
  },
})

-- Add this to your init.lua
vim.filetype.add({
  pattern = {
    -- Matches any file inside ~/.config/i3/config.d/
    ['.*/.config/i3/config%.d/.*'] = 'i3config',
  },
})

