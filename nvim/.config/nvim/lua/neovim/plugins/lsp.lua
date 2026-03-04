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

vim.api.nvim_create_user_command('LspRestart', function()
    local bufnr = vim.api.nvim_get_current_buf()
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        vim.lsp.stop_client(client.id)
    end
    vim.defer_fn(function() vim.cmd('edit') end, 100)
    print("󰑐 LSP Restarted")
end, {})

vim.api.nvim_create_user_command('LspStatus', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then return print("󰅚 No LSP clients attached") end

    print("󰒋 LSP Status [Buf " .. bufnr .. "]")
    for _, client in ipairs(clients) do
        local caps = client.server_capabilities
        print(string.format("\n󰌘 %s (ID: %d)", client.name, client.id))
        print("  Root: " .. (client.config.root_dir or "N/A"))

        local features = {}
        if caps.completionProvider then table.insert(features, "󰄬 completion") end
        if caps.hoverProvider then table.insert(features, "󰄬 hover") end
        if caps.definitionProvider then table.insert(features, "󰄬 definition") end
        print("  " .. table.concat(features, "  "))
    end
end, { desc = "Show LSP status" })

---
--- STATUSLINE
---

local function get_git_branch()
    local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
    return (branch ~= "") and ("󰊢 " .. branch .. " ") or ""
end

local function get_lsp_status()
    local names = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, client.name)
    end
    return #names > 0 and (" 󰒋 " .. table.concat(names, ",")) or ""
end

local function get_formatter_status()
    local ok, conform = pcall(require, "conform")
    if not ok then return "" end
    local formatters = conform.list_formatters_to_run(0)
    return #formatters > 0 and (" 󰉿 " .. formatters[1].name) or ""
end

-- We use a simpler function that returns a statusline-compatible string
_G.sl_status = function()
    local parts = {
        get_git_branch(),
        "%f %m %r", -- File name, modified, readonly
        "%=",       -- Right align
        get_formatter_status(),
        get_lsp_status(),
        " %l:%c %p%%" -- Position
    }
    return table.concat(parts, "")
end

vim.opt.statusline = "%!v:lua.sl_status()"
