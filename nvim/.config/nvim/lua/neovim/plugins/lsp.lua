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
        -- Imports
        local lspconfig = require("lspconfig")
        -- local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local keymap = vim.keymap

        -- Diagnostic Configuration
        vim.diagnostic.config({
            virtual_text = {
                prefix = "■",
                source = "if_many",
            },
            signs = true,
            float = {
                border = "rounded",
                source = "always",
            },
        })

        -- Diagnostic Signs
        --local signs = { Error = "E ", Warn = "W ", Hint = "H ", Info = "I " }
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        -- LSP Capabilities
        local original_capabilities = vim.lsp.protocol.make_client_capabilities()
        local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)

        -- Keybindings and On-Attach
        local opts = { noremap = true, silent = true }
        local on_attach = function(client, bufnr)
            opts.buffer = bufnr

            -- Attach LSP signature
            require("lsp_signature").on_attach({
                bind = true,
                handler_opts = { border = "rounded" },
            }, bufnr)

            -- Keybindings
            local keybindings = {
                { mode = "n", lhs = "gR",         rhs = vim.lsp.buf.references,                   desc = "Show LSP references" },
                { mode = "n", lhs = "gr",         rhs = vim.lsp.buf.declaration,                  desc = "Go to declaration" },
                { mode = "n", lhs = "gd",         rhs = vim.lsp.buf.definition,                   desc = "Go to definition" },
                { mode = "n", lhs = "<leader>rn", rhs = vim.lsp.buf.rename,                       desc = "Smart rename" },
                { mode = "n", lhs = "<leader>D",  rhs = "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Show buffer diagnostics" },
                {
                    mode = "n",
                    lhs = "<leader>gp",
                    rhs = function()
                        vim.diagnostic.open_float({ border = "rounded", scope = "line", focusable = false })
                    end,
                    desc = "Show line diagnostics",
                },
                { mode = "n", lhs = "M",          rhs = vim.lsp.buf.hover,                                  desc = "Show documentation" },
                { mode = "n", lhs = "<leader>ca", rhs = vim.lsp.buf.code_action,                            desc = "Code actions" },
                { mode = "n", lhs = "<leader>ws", rhs = require("telescope.builtin").lsp_workspace_symbols, desc = "Workspace symbols" },
            }

            for _, binding in ipairs(keybindings) do
                keymap.set(binding.mode, binding.lhs, binding.rhs,
                    { noremap = true, silent = true, buffer = bufnr, desc = binding.desc })
            end
        end

        -- LSP Server Configurations
        local servers = {
            -- Web Development
            html = {
                filetypes = { "html", "templ", "css" },
            },
            ts_ls = {
                filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayFunctionLikeReturnTypeHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayFunctionLikeReturnTypeHints = true,
                        },
                    },
                },
            },
            eslint = {
                filetypes = { "typescript", "javascript" },
            },
            eslint_d = {
                filetypes = { "typescript", "javascript" },
            },
            prismals = {
                filetypes = { "prisma" }
            },
            emmet_language_server = {
                filetypes = {
                    "html", "templ", "css", "javascriptreact", "typescriptreact",
                    "jsx", "tsx", "markdown",
                },
            },
            jsonls = {},

            clangd = {
                filetypes = { "c", "cpp" },
                cmd = {
                    "clangd",
                    "--background-index",              -- Index in background
                    "--clang-tidy",                    -- Enable clang-tidy
                    "--header-insertion=never",        -- Disable auto-inserting headers
                    "--completion-style=detailed",
                    "--query-driver=/usr/bin/clang++", -- Adjust path if needed
                },
                single_file_support = true,
                root_dir = function(fname)
                    return lspconfig.util.root_pattern(
                        'compile_commands.json',
                        'compile_flags.txt',
                        '.git'
                    )(fname) or vim.fn.getcwd()
                end,
            },
            -- Systems Programming
            -- clangd = {
            --     cmd = { "clangd", "--background-index" },
            --     filetypes = { "c", "cpp" },
            --     root_dir = lspconfig.util.root_pattern(".clangd", ".git"),
            --     settings = {
            --         clangd = {
            --             fallbackFlags = { "-std=c17" },
            --         },
            --     },
            -- },
            zls = {
                filetypes = { "zig" },
            },

            -- Scripting and Others
            pylsp = {
                filetypes = { "python" },
            },
            bashls = {
                filetypes = { "sh" },
            },
            gopls = {
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
                settings = {
                    gopls = {
                        completeUnimported = true,
                        usePlaceholders = true,
                        analyses = { unusedparams = true },
                    },
                },
            },
            lua_ls = {
                filetypes = { "lua" },
                root_dir = lspconfig.util.root_pattern(".git", "init.lua"),
            },
            markdown_oxide = {
                filetypes = { "markdown" },
            },
        }

        -- Setup LSP Servers
        for server, config in pairs(servers) do
            lspconfig[server].setup(vim.tbl_deep_extend("force", {
                capabilities = capabilities,
                on_attach = on_attach,
            }, config))
        end
    end,
}
