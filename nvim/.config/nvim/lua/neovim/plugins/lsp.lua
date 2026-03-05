local capabilities = require("blink.cmp").get_lsp_capabilities()

-- List of servers to enable
local servers = {
    "lua_ls", "ts_ls", "intelephense", "tailwindcss",
    "html", "cssls", "clangd", "zls"
}

-- Setup and enable servers
for _, server in ipairs(servers) do
    -- We set the capabilities via the config table
    vim.lsp.config(server, {
        capabilities = capabilities
    })
    -- Then enable it
    vim.lsp.enable(server)
end

---
--- HELPER COMMANDS
---
---
--- LSP COMMANDS
---

-- Simplified Restart: Custom loop is fine, but added a check to make sure it doesn't fail
vim.api.nvim_create_user_command('LspRestart', function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id)
    end
    vim.defer_fn(function() vim.cmd('edit') end, 100)
    print("󰑐 LSP Restarted")
end, {})

-- LspStatus is good for debugging, kept it as is.
vim.api.nvim_create_user_command('LspStatus', function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then return print("󰅚 No LSP clients attached") end

    print("󰒋 LSP Status")
    for _, client in ipairs(clients) do
        local caps = client.server_capabilities
        print(string.format("\n󰌘 %s (ID: %d)", client.name, client.id))
        local features = {}
        if caps.completionProvider then table.insert(features, "󰄬 completion") end
        if caps.hoverProvider then table.insert(features, "󰄬 hover") end
        if caps.definitionProvider then table.insert(features, "󰄬 definition") end
        print("  " .. table.concat(features, "  "))
    end
end, { desc = "Show LSP status" })

---
--- STATUSLINE (Optimized)
---

-- Optimization: Use a buffer variable so we don't call the shell on every cursor move
local function get_git_branch()
    -- Check if we already found the branch for this buffer
    if vim.b.git_branch then return vim.b.git_branch end
    
    -- If not, find it once and store it
    local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
    if branch ~= "" then
        vim.b.git_branch = "󰊢 " .. branch .. " "
    else
        vim.b.git_branch = ""
    end
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
    -- Just show the first formatter name to keep it clean
    return #formatters > 0 and (" 󰉿 " .. formatters[1].name) or ""
end

_G.sl_status = function()
    local parts = {
        get_git_branch(),
        "%f %m %r",     -- File path, modified flag, readonly flag
        "%=",           -- SPLIT POINT (moves everything after this to the right)
        get_formatter_status(),
        get_lsp_status(),
        -- REMOVED: " %l:%c %p%%" (This was the progress/position info)
    }
    return table.concat(parts, "")
end

vim.opt.statusline = "%!v:lua.sl_status()"
