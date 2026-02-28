
local blink = require("blink.cmp")

return {
    cmd = { "emmet_language_server" },
    filetypes = {
        "html",
        "javascriptreact",
        "typescriptreact",
        "typescript",
        "javascript",
    },
    root_markers = { "index.html", ".git" },
    init_options = { provideFormatter = true },
    -- capabilities = vim.tbl_deep_extend(
    --     "force",
    --     {},
    --     vim.lsp.protocol.make_client_capabilities(),
    --     blink.get_lsp_capabilities()
    -- ),
}
