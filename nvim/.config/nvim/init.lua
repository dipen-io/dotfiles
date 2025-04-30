require("neovim.core.keymaps")
require("neovim.core.settings")
require("neovim.core.autocmd")
-- require("neovim.core.Todo")
require("neovim.lazy")

-- This is good while im using vim-illuminate
vim.cmd('hi IlluminatedWordText guibg=none gui=underline')
vim.cmd('hi IlluminatedWordRead guibg=none gui=underline')
vim.cmd('hi IlluminatedWordWrite guibg=none gui=underline')
vim.keymap.set('i', '<C-d>', '<C-w>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-d>', 'bdiw', { noremap = true, silent = true })
