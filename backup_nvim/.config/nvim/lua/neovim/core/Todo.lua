-- Constants for reusability
local README_FILE = vim.fn.expand("~/.config/nvim/README.md")
local README_NAME = "-TODO-"

-- Utility to check if a file exists and is readable
local function file_exists(path)
    return vim.fn.filereadable(path) == 1
end

-- Find or open README buffer tied to the actual file
local function get_or_open_readme_buffer()
    -- Check if the README buffer is already open
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == README_FILE then
            return buf -- Reuse the existing buffer
        end
    end

    -- If not open, create a buffer and load the file
    local buf = vim.api.nvim_create_buf(true, false) -- listed, not scratch
    vim.api.nvim_buf_set_name(buf, README_FILE)

    -- Load the file if it exists, or start fresh
    if file_exists(README_FILE) then
        vim.api.nvim_buf_call(buf, function() vim.cmd("e " .. README_FILE) end)
    else
        vim.api.nvim_buf_set_option(buf, "modified", false) -- Mark as unmodified initially
    end

    -- Ensure Markdown filetype for syntax highlighting and LSP
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    return buf
end

-- Save README content to file
local function save_readme(buf)
    vim.api.nvim_buf_call(buf, function() vim.cmd("w") end)
    print("README saved to " .. README_FILE)
end

-- Create and configure the README window
local function open_readme_window()
    local buf = get_or_open_readme_buffer()

    local width, height = math.floor(vim.o.columns * 0.6), math.floor(vim.o.lines * 0.6)
    local col, row = math.floor((vim.o.columns - width) / 2), math.floor((vim.o.lines - height) / 2)

    local opts = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
        title = README_NAME,
        title_pos = "center",
    }

    -- Check if the buffer is already in a floating window
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf and vim.api.nvim_win_get_config(win).relative ~= "" then
            vim.api.nvim_win_set_config(win, opts) -- Reconfigure existing window
            vim.api.nvim_set_current_win(win)
            return buf, win
        end
    end

    local win = vim.api.nvim_open_win(buf, true, opts)
    return buf, win
end

-- Setup README window with keybindings
local function setup_readme()
    local buf, win = open_readme_window()

    local keymaps = {
        ["fj"] = save_readme, -- Save the README manually if needed
        ["q"] = function()
            -- Save before closing
            save_readme(buf)
            vim.api.nvim_win_close(win, true)
            -- Delete the buffer only if it’s not visible in another window
            local wins = vim.api.nvim_list_wins()
            for _, w in ipairs(wins) do
                if vim.api.nvim_win_get_buf(w) == buf then
                    return -- Buffer is still in use, don’t delete
                end
            end
            -- Since we saved, it’s safe to delete if no other windows use it
            vim.api.nvim_buf_delete(buf, { force = true })
        end,
    }

    for key, fn in pairs(keymaps) do
        vim.api.nvim_buf_set_keymap(buf, "n", key, "", {
            noremap = true,
            silent = true,
            callback = function() fn(buf) end,
        })
    end
end

-- Register command and keybinding
vim.api.nvim_create_user_command("Readme", setup_readme, { nargs = 0 })
vim.api.nvim_set_keymap("n", "<leader>[", ":Readme<CR>", { noremap = true, silent = true })

