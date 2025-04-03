return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    { path = "snacks.nvim",        words = { "Snacks" } },
                    { path = "lazy.nvim",          words = { "LazyVim" } },
                },
            },
        },
    },
    config = function()
        -- import lspconfig plugin
        local lspconfig = require("lspconfig")
        local utils = require("lspconfig/util")

        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local keymap = vim.keymap

        local opts = { noremap = true, silent = true }
        local on_attach = function(client, bufnr)
            opts.buffer = bufnr


            -- Attach LSP signature
            require("lsp_signature").on_attach({
                bind = true,
                handler_opts = {
                    border = "rounded",
                },
            }, bufnr)

            -- set keybinds
            opts.desc = "Show LSP references"
            keymap.set("n", "gR", vim.lsp.buf.references, opts) -- show definition, references

            opts.desc = "Go to declaration"
            keymap.set("n", "gr", vim.lsp.buf.declaration, opts) -- go to declaration

            opts.desc = "Show LSP definitions"
            keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- go to defination


            opts.desc = "Smart rename"
            keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

            opts.desc = "Show buffer diagnostics"
            keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

            opts.desc = "Show line diagnostics"
            keymap.set("n", "<leader>g", vim.diagnostic.open_float, opts) -- show diagnostics for line

            opts.desc = "Go to previous diagnostic"
            keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

            opts.desc = "Go to next diagnostic"
            keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

            opts.desc = "Show documentation for what is under cursor"
            keymap.set("n", "N", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
            -- keymap.set("n", "gr", require("telescope.builtin").lsp_references)
        end

        -- used to enable autocompletion (assign to every lsp server config)
        -- local capabilities = cmp_nvim_lsp.default_capabilities()
        -- local capabilities = require('blink.cmp').get_lsp_capabilities()

        -- new one
        local original_capabilities = vim.lsp.protocol.make_client_capabilities()
        local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)

        local signs = { Error = "E ", Warn = "W ", Hint = "H ", Info = "I " }
        -- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- configure html server
        lspconfig["html"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {
                "templ",
                "html",
                "css",
            },
        })
        lspconfig.jsonls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
        -- configure typescript server with plugin
        lspconfig["ts_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig.eslint.setup({
            capabilties = capabilities,
        })

        -- configure emmet language server
        lspconfig["emmet_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })

        lspconfig.emmet_language_server.setup({
            capabilities = capabilities,
            filetypes = {
                "templ",
                "html",
                "css",
                "javascriptreact",
                "typescriptreact",
                "javascript",
                "typescript",
                "jsx",
                "tsx",
                "markdown",
            },
        })

        lspconfig["clangd"].setup({
            capabilities = capabilities,
            cmd = { "clangd", "--background-index" },
            filetypes = { "c", "cpp" },
            root_dir = lspconfig.util.root_pattern(".clangd", ".git"),
            settings = {
                clangd = {
                    fallbackFlags = { "-std=c17" }, -- Add any additional flags here
                },
            },
            on_attach = on_attach,

        })

        -- -- configure css server
        -- lspconfig["cssls"].setup({
        -- 	capabilities = capabilities,
        -- 	on_attach = on_attach,
        -- })
        lspconfig["pylsp"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "py", "python" },
        })
        --
        --
        -- -- configure tailwindcss server
        -- lspconfig["tailwindcss"].setup({
        -- 	capabilities = capabilities,
        -- 	on_attach = on_attach,
        -- })

        -- lspconfig["rust_analyzer"].setup({
        --     capabilities = capabilities,
        --     on_attach = on_attach,
        --     filetypes = { "rs", "rust" },
        -- })
        lspconfig["bashls"].
            setup({
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "sh" },
            })

        -- --autocompletion configuration for golang
        lspconfig["gopls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_dir = utils.root_pattern("go.work", "go.mod", ".git"),
            settings = {
                gopls = {
                    completeUnimported = true,
                    usePlaceholders = true,
                    analyses = {
                        unusedparams = true,
                    },
                },
            },
        })

        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "lua" },
        })
        lspconfig["markdown_oxide"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "md", "markdown" },
        })
        lspconfig["zls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "zig" },
        })
    end,
}
