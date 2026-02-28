return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
    },
    opts = {
        ui = {
            width = 0.8,
            height = 0.8,
            icons = {
                package_installed = "",
                package_pending = "",
                package_uninstalled = "",
            },
        },
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")

        mason.setup({})

        mason_lspconfig.setup({
            ensure_installed = {
                "lua_ls",
                "html",
                "emmet_language_server",
                "cssls",
                -- "rust_analyzer",
                -- "templ",
                -- "gopls",
                "ts_ls",
                "bashls",
                -- "eslint",
                -- "clangd",
                "jsonls",
                -- "tailwindcss",
                -- "yamlls",
                -- "emmet_ls",
                -- "prettierd"
            },
            automatic_installation = true,
        })
    end,
}
