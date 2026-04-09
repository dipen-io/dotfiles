local capabilities = require("blink.cmp").get_lsp_capabilities()

local servers = {
    "lua_ls", "ts_ls", "bashls", "intelephense",
    "go", "tailwindcss", "html", "cssls", "clangd", "zls", "astro",
}

for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end

vim.api.nvim_create_user_command('LspRestart', function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id)
    end
    vim.defer_fn(function() vim.cmd('edit') end, 100)
    print("󰑐 LSP Restarted")
end, {})

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
