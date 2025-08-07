vim.g.mapleader = " "
vim.g.maplocalleader = " "
local set = vim.keymap.set
local api = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>ii', function()
    local filename = vim.fn.expand('%')
    local filetype = vim.bo.filetype

    local commands = {
        cpp = 'g++ "' .. filename .. '" -o /tmp/a.out && /tmp/a.out; rm /tmp/a.out',
        c = 'gcc "' .. filename .. '" -o /tmp/a.out && /tmp/a.out; rm /tmp/a.out',
        go = 'go run "' .. filename .. '"',
        javascript = 'node "' .. filename .. '"',
        js = 'node "' .. filename .. '"',
        python = 'python3 "' .. filename .. '"',
        sh = 'bash "' .. filename .. '"',
    }

    local cmd = commands[filetype]
    if not cmd then
        vim.notify("Unsupported file type: " .. filetype, vim.log.levels.ERROR)
        return
    end

    -- Write command to a temporary shell script
    local script_path = "/tmp/vim_exec.sh"
    local file = io.open(script_path, "w")
    file:write("#!/bin/bash\nclear\n" .. cmd .. "\n")
    file:close()
    vim.fn.system({"chmod", "+x", script_path})

    -- Open terminal and execute script
    -- vim.cmd('belowright split | resize 15 | terminal')
    vim.cmd('rightbelow vsplit | vertical resize 50 | terminal')

    vim.defer_fn(function()
        local term_chan = vim.b.terminal_job_id
        vim.fn.chansend(term_chan, script_path .. '\n')
    end, 100)
end, { desc = "Run current file in terminal" })

vim.keymap.set("n", "<C-n>", "<cmd> silent !tmux neww /home/void/script/python.py<CR>",
    { noremap = true, desc = "tmux selection command" })

vim.keymap.set("n", "<C-f>", "<cmd> silent !tmux neww /home/void/script/tmux_sessionaizer.sh<CR>",
    { noremap = true, desc = "tmux sessionizer" })
-- Navigate paragraphs with [ and ] instead of { and }
vim.keymap.set('n', '[', '{', { noremap = true, desc = "Jump to previous empty line" })
vim.keymap.set('n', ']', '}', { noremap = true, desc = "Jump to next empty line" })

-- Making new file or navigating
api('n', '<leader>n', ':e <Space>', { noremap = true })

set("v", "<leader>r", "\"hy:%s/<C-r>h//g<left><left>") --replac

-- For sourceing this current file
set("n", "<leader><leader>x", "<cmd>source %<CR>")

--make the current file executable
set("n", "<leader><leader>e", ":!chmod +x %<cr>", { desc = "make quick executable" })


-- set("t", "<esc><esc>", "<c-\\><c-n>")
set("t", "jf", "<c-\\><c-n>")
-- Execute any line
set("n", "<leader>x", ":.lua<CR>")
set("v", "<leader>x", ":lua<CR>")

--scroll down and up without smooth
set("n", "<S-f>", "<C-d>zz")
set("n", "<S-h>", "<C-u>zz")

vim.keymap.set('i', '<C-d>', '<Esc>dawi', { noremap = true, silent = true })
set('n', '<C-d>', 'daw', { noremap = true, silent = true })

set({ "n", "o", "x" }, "ss", "0", { desc = "Jump to beginning of line" })
set({ "n", "o", "x" }, "e", "g_", { desc = "Jump to end of line" })

set("n", "m", "%", opt)

vim.keymap.set("v", "p", '"_dP')

-- Navigating through the splits
set("n", "<C-j>", "<c-w><c-h>")
-- set("n", "<c-h>", "<c-w><c-j>")
-- set("n", "<c-l>", "<c-w><c-k>")
set("n", "<C-k>", "<c-w><c-l>")

set("n", "<space>tp", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end)
-- These mappings control the size of splits (height/width)
set("n", "<M-,>", "<c-w>5<")
set("n", "<M-.>", "<c-w>5>")

-- open explorar
-- api('n', '<leader>pf', ':Ex<CR>', opt)
vim.keymap.set('n', '<leader>ve', '<cmd>Sex!<CR>')

-- move line --
set("v", "J", ":m '>+1<CR>gv=gv")
set("v", "K", ":m '<-2<CR>gv=gv")


-- Map Shift + T to go to the end of the page, and scroll the window to the top
vim.keymap.set('n', '<S-T>', function()
    -- Move the cursor to the last line of the file (end of the page)
    vim.cmd('normal! G')

    -- Scroll the window so that the cursor is at the top of the screen
    vim.cmd('normal! zt')
end)

-- Key mapping only for Normal mode
vim.keymap.set('n', '<A-;>', function()
    local pos = { line = vim.fn.line('.'), col = vim.fn.col('.') }
    vim.cmd('normal! zt')            -- Scroll to the top
    vim.fn.cursor(pos.line, pos.col) -- Restore the cursor position
end)

-- formate --
-- set(
--     "n",
--     "fj",
--     "<cmd>lua vim.lsp.buf.format{ async = true }<cr>",
--     { noremap = true, silent = true, desc = "Format" }
-- )

-- Move normally between wrapped lines
set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Keymaps for better default experience
set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

--indenting--
set("v", "<", "<gv")
set("v", ">", ">gv")

--undo--
set("n", "U", "<C-r>", { noremap = true })

-- move freely in insert mode --
api("i", "<C-j>", "<Down>", { noremap = true })
api("i", "<C-k>", "<Up>", { noremap = true })
api("i", "<C-h>", "<Left>", { noremap = true })
api("i", "<C-l>", "<Right>", { noremap = true })

--command mode--
api("n", ";", ":", { noremap = true })

--close cureent buffer --
set("n", "q", "<cmd>bd<CR>", { noremap = true, silent = true, desc = "Close current buffer" })

-- Navigate buffers
set("n", "<S-k>", ":bnext<CR>", { noremap = true })
set("n", "<S-j>", ":bprevious<CR>", { noremap = true })

-- Select all --
set("n", "si", "gg<S-v>G")

-- remove when highlight search --
api("n", "<Esc>", "<cmd>noh<CR>", opt)

--split--
set("n", "ff", ":vsplit <CR>")
-- set("n", "ss", ":split <cr>")
set("n", "st", ":tabnew <cr>")

-- Isert -> Normal --
set("i", "jf", "<Esc>")

-- Visual -> Normal
set("v", "o", "<Esc>")
-- v,i -> Normal
set("x", "o", "<Esc>")
set("i", "<C-c>", "<Esc>")
api('n', 'c', 'V', opt)

--formating or indenting default
set("x", "e", "=")

api("n", "fj", ":w<CR>", { silent = false })
api("n", "<leader>q", ":q!<CR>", { silent = true })
api("n", "<leader>wq", ":wq<CR>", { silent = true })

-- help in word seaching --
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

set("n", "<leader>m", ":terminal<CR>", opt)
set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

