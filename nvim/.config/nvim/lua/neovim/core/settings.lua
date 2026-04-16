-- vim.opt.guicursor = ""
-- vim.g.mapleader = " "
vim.g.mapleader = ","

-- General Options
vim.opt.cmdheight = 0 -- hide the message
vim.o.background="dark"
vim.wo.cursorline = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.o.completeopt = "menuone,noselect"
vim.opt.autoindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.showmode = false
vim.opt.smartindent = true
vim.opt.smoothscroll = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Tabs & Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

--Search 
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Performance & Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.updatetime = 50
vim.opt.fsync = true
vim.opt.isfname:append("@-@")
vim.opt.wildignore:append({ "*/node_modules/*" })

-- UI Customization
vim.opt.signcolumn = "yes:1"
vim.opt.winborder= 'rounded'
vim.opt.shortmess:append("c")  -- Hide "match x of y" messages
vim.cmd(":hi statusline guibg = NONE") --remove the statualne color
--vim.o.timeoutlen = 200

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      scope = "cursor",
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    })
  end,
})


-- netrw
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.o.completeopt = "menuone,noselect"

vim.opt.backspace = { "indent", "eol", "start" } -- for xterm backspace work
vim.keymap.set("i", "<C-H>", "<BS>", { noremap = true })


vim.keymap.set('n', 'M', vim.lsp.buf.hover, { silent = true })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

-- Enable document colors with virtual text style by default
vim.lsp.document_color.enable(true, nil, { style = 'virtual' })

-- Cursor appearance and blinking
vim.o.guicursor = table.concat({
  'n-v-c-sm:block-Cursor', -- Normal, Visual, Command, Showmatch: block cursor
  'i-ci-ve:ver25-Cursor', -- Insert, Command-insert, Visual-exclusive: vertical bar (25% width)
  'r-cr-o:hor20-Cursor', -- Replace, Command-replace, Operator-pending: horizontal bar (20% height)
  'a:blinkwait500-blinkoff500-blinkon500',
}, ',')

-- Fill chars
vim.opt.fillchars:append({
  diff = '░',
  eob = ' ',
  fold = '⋯',
  foldopen = '▼',
  foldclose = '▶',
  foldsep = '┊',
  msgsep = '━',
})

-- Enable Inlay Hints (Neovim 0.10+)
if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true)
end

-- LSP & Diagnostics
vim.diagnostic.config({
  virtual_text = false, -- Keep UI clean
  underline = true,
  signs = true,
  float = { border = "rounded" },
})
