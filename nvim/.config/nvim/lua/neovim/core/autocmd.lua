-- working
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.keymap.set("n", "<CR>", "<cr><C-w><C-p>", { buffer = true })
    end
})

-- shwo key
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Wait a brief moment for plugins to load
        vim.defer_fn(function()
            if vim.fn.exists(":ShowkeysToggle") == 2 then
                vim.cmd("ShowkeysToggle")
            else
                vim.notify("ShowkeysToggle not found - make sure showkeys.nvim is installed",
                    vim.log.levels.WARN)
            end
        end, 100) -- 100ms delay
    end,
    once = true   -- Only run once on startup
})

-- Keep the cursor position when yanking
local cursorPreYank

vim.keymap.set({ "n", "x" }, "y", function()
    cursorPreYank = vim.api.nvim_win_get_cursor(0)
    return "y"
end, { expr = true })

vim.keymap.set("n", "Y", function()
    cursorPreYank = vim.api.nvim_win_get_cursor(0)
    return "y$"
end, { expr = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        if vim.v.event.operator == "y" and cursorPreYank then
            vim.api.nvim_win_set_cursor(0, cursorPreYank)
        end
    end,
})

-- When i open any help it directly open in right split helpful
local api = vim.api
local autocmd = api.nvim_create_autocmd
local cmd = vim.cmd
local bo = vim.bo

autocmd("FileType", {
    desc = "Automatically Split help Buffers to the right",
    pattern = "help",
    command = "wincmd L",
})

-- cursorline
autocmd({ "UIEnter", "ColorScheme" }, {
    desc =
    "Corrects terminal background color according to colorscheme, see: https://www.reddit.com/r/neovim/comments/1ehidxy/you_can_remove_padding_around_neovim_instance/",
    callback = function()
        if api.nvim_get_hl(0, { name = "Normal" }).bg then
            io.write(string.format("\027]11;#%06x\027\\", api.nvim_get_hl(0, { name = "Normal" }).bg))
        end
        autocmd("UILeave", {
            callback = function()
                io.write("\027]111\027\\")
            end,
        })
    end,
})


-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Automatically enter insert mode when re-entering a terminal window
api.nvim_create_autocmd("WinEnter", {
    group = terminal,
    pattern = "*",
    callback = function()
        if bo.filetype == "terminal" and vim.g.catgoose_terminal_enable_startinsert then
            cmd("startinsert")
        end
    end,
})

-- add all buffers filenames at the bottom of the file at statusbar or statusline whatever
-- I know there is better ways to do it this works for me !
vim.o.statusline = "%!v:lua.ShowBuffers()"

function ShowBuffers()
    local current_buf = vim.fn.bufnr('%')                   -- Get f the current buffer number
    local buffers = vim.fn.getbufinfo({ buflisted = true }) -- Get all listed buffers
    local buffer_list = {}

    for _, buf in ipairs(buffers) do
        local buf_name = vim.fn.fnamemodify(buf.name, ":t") -- Get the file name
        if buf.bufnr == current_buf then
            -- ADD symbold and color in current buffer name
            table.insert(buffer_list, "%#CurrentBuffer#<" .. buf_name .. ">%>")
        else
            table.insert(buffer_list, buf_name)
        end
    end

    return table.concat(buffer_list, " | ") --Split
end

vim.api.nvim_set_hl(0, "CurrentBuffer", { fg = "#FFFFFF", bg = "#000000", italic = true })

--ADD color to the bottom line
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.api.nvim_set_hl(0, "StatusLine", { bg = "#000000", fg = "#FFFFFF" })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#000000", fg = "#808080" })
    end
})

-- show cursor line only in active window
local cursorGrp = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    pattern = "*",
    command = "set cursorline",
    group = cursorGrp,
})
vim.api.nvim_create_autocmd(
    { "InsertEnter", "WinLeave" },
    { pattern = "*", command = "set nocursorline", group = cursorGrp }
)
--Restore cursor to file position in prevous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.cmd('normal! g`"zz')
        end
    end,
})



-- Terminal
vim.g.mapleader = " "
local term_bufnr = -1

-- Function to toggle terminal
local function toggle_terminal()
    if term_bufnr == -1 or not vim.api.nvim_buf_is_valid(term_bufnr) then
        -- If no terminal exists or the buffer is invalid, create a new one
        vim.cmd("belowright split | terminal")
        term_bufnr = vim.api.nvim_get_current_buf()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    else
        local term_win = vim.fn.bufwinid(term_bufnr)
        if term_win ~= -1 then
            -- If terminal is visible, hide it (check if it's the only window)
            if vim.fn.winnr("$") > 1 then
                vim.api.nvim_win_close(term_win, true)
            else
                print("Cannot close the last window")
            end
        else
            -- If terminal is hidden, show it
            vim.cmd("belowright split")
            vim.api.nvim_set_current_buf(term_bufnr)
        end
    end
end

-- Keymap for <leader>m
vim.keymap.set("n", "<leader>m", toggle_terminal, { noremap = true, silent = true })


-- This sets up the keymap only for gitcommit files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    callback = function()
        -- Mapping q to quit the commit file
        vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':q!<CR>', { noremap = true, silent = true })
    end
})

-- if fileType is xinitrc then it is treated as sh file
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = ".xinitrc",
    command = "set filetype=sh"
})
