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

-- Reset cursor to underline when exiting neovim
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.opt.guicursor = "a:hor20"
    -- send reset escape sequence to terminal
    io.write("\27[ q")
  end,
})

-- Create an augroup named 'DynamicCursorLine' and clear it if it exists
local cursorGrp = vim.api.nvim_create_augroup("DynamicCursorLine", { clear = true })

-- Disable cursorline when entering Insert mode or leaving a window
-- Reset cursor on exit
--
-- fix cursor reset on neovim exit
vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "*",
  callback = function()
    io.write("\027[4 q")
    io.flush()
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

-- for same ColorScheme as left side in fuzzy find
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        local bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
        vim.api.nvim_set_hl(0, "SnacksPickerPreview", { bg = bg })
        vim.api.nvim_set_hl(0, "SnacksPickerPreviewBorder", { bg = bg })
        vim.api.nvim_set_hl(0, "SnacksPickerPreviewTitle", { bg = bg })
    end,
})

-- for enabling pdf viewing
 -- vim.api.nvim_create_autocmd("BufReadPost", {
 --   pattern = "*.pdf",
 --   callback = function()
 --     local file_path = vim.api.nvim_buf_get_name(0)
 --     require("pdfview").open(file_path)
 --   end,
 -- })
