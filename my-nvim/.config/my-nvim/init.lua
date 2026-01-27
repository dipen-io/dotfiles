require("neovim.lazy")
-- require("neovim.lsp")
require("neovim.core.keymaps")
require("neovim.core.autocmd")
require("neovim.core.settings")
require("neovim.core.statusline")

vim.filetype.add({
  filename = {
    ['init'] = 'sh',
  },
  pattern = {
    ['.*/river/init'] = 'sh',
  },
})
