vim.opt.guicursor = ""
vim.g.mapleader = " "
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.o.completeopt = "menuone,noselect"
-- vim.o.background = "dark"
vim.opt.autoindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.showmode = false
vim.opt.smoothscroll = true
-- vim.opt.numberwidth=3

vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
--vim.o.timeoutlen = 200

vim.opt.scrolloff = 8

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 50
-- hide this two
-- vim.opt.colorcolumn = "100"
vim.opt.signcolumn = "yes"
vim.opt.signcolumn = "yes:1"
vim.opt.isfname:append("@-@")
vim.opt.wildignore:append({ "*/node_modules/*" })

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
