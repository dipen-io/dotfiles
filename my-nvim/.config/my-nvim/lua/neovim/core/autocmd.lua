local api = vim.api
local autocmd = api.nvim_create_autocmd
-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

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

-- Create an augroup named 'DynamicCursorLine' and clear it if it exists
local cursorGrp = vim.api.nvim_create_augroup("DynamicCursorLine", { clear = true })

-- Disable cursorline when entering Insert mode or leaving a window
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
    group = cursorGrp,
    callback = function()
        -- Turn off cursorline in the current window
        vim.wo.cursorline = false
    end,
})

-- Enable cursorline when leaving Insert mode or entering a window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    group = cursorGrp,
    callback = function()
        -- Turn on cursorline in the current window
        vim.wo.cursorline = true
    end,
})

