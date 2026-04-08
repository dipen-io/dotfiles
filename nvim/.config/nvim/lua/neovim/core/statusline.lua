vim.o.statusline = "%!v:lua.ShowBuffers()"

-- function ShowBuffers()
--     local current_buf = vim.fn.bufnr('%')
--     local buffers = vim.fn.getbufinfo({ buflisted = true })
--     local buffer_list = {}
--
--     for _, buf in ipairs(buffers) do
--         local buf_name = vim.fn.fnamemodify(buf.name, ":t")
--         if buf_name == "" then buf_name = "[No Name]" end
--
--         if buf.bufnr == current_buf then
--             table.insert(buffer_list, "%#CurrentBuffer#<<" .. buf_name .. ">>%*")
--         else
--             table.insert(buffer_list, buf_name)
--         end
--     end
--
--     return table.concat(buffer_list, " | ")
-- end

local M = {}

local function get_git_branch()
    if vim.b.git_branch then return vim.b.git_branch end
    local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
    vim.b.git_branch = branch ~= "" and ("󰊢 " .. branch .. " ") or ""
    return vim.b.git_branch
end

local function get_lsp_status()
    local names = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, client.name)
    end
    return #names > 0 and ("  " .. table.concat(names, ",")) or ""
end

local function get_formatter_status()
    local ok, conform = pcall(require, "conform")
    if not ok then return "" end
    local formatters = conform.list_formatters_to_run(0)
    return #formatters > 0 and (" 󰉿 " .. formatters[1].name) or ""
end

local function get_tmux_info()
    if not os.getenv("TMUX") then return "" end
    local session = vim.fn.system("tmux display-message -p '#S'"):gsub("\n", "")
    local window = vim.fn.system("tmux display-message -p '#W'"):gsub("\n", "")
    return session .. " | " .. window
end

_G.sl_status = function()
    local parts = {
        get_git_branch(),
        "%f %m %r",
        "%=",
        get_formatter_status(),
        get_lsp_status(),
        "  ",
        get_tmux_info(),
    }
    return table.concat(parts, "")
end

vim.opt.statusline = "%!v:lua.sl_status()"

return M
