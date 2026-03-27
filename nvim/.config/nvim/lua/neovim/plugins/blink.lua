return {
    -- LuaSnip (make sure it's properly initialized)
    { "L3MON4D3/LuaSnip", lazy = true },

    -- lazydev.nvim for Blink
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- blink.nvim configuration
    {
        "saghen/blink.cmp",
        -- version = "*",
    version = "v0.*",
        dependencies = {
            "rafamadriz/friendly-snippets",  -- Friendly snippets for various languages
            "folke/lazydev.nvim",            -- LazyDev for Blink integration
        },
        config = function()
            -- Blink CMP setup
            require("blink.cmp").setup({
                snippets = { preset = "luasnip" },
                signature = {
                    enabled = true,
                    trigger = {
                        enabled = true,
                        show_on_insert = true,  -- Show when typing (
                        show_on_trigger_character = true,
                    },
                    window = {
                        border = 'rounded',
                    },
                },
                appearance = {
                    nerd_font_variant = "normal",  -- Nerd fonts for Blink
                },
                sources = {
                    default = { "lsp", "path", "snippets", "lazydev", "buffer" },
                    providers = {
                        lsp = {
                            async = true,
                            timeout_ms =  100,
                            score_offset = 4,
                        },
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            score_offset = 100,
                        },
                    },
                },

                -- cmdline = {
                --  enabled = true,
                --   keymap = {
                --     preset = "cmdline",
                --     ["<Right>"] = false,
                --     ["<Left>"] = false,
                --   },
                cmdline = {
                  enabled = true,
                  keymap = {
                    preset = "cmdline",
                    ["<Right>"] = { "fallback" },
                    ["<Left>"] = { "fallback" },
                  },
                  completion = {
                    list = { selection = { preselect = false } },
                    menu = {
                      auto_show = function(ctx)
                        return vim.fn.getcmdtype() == ":"
                      end,
                    },
                    ghost_text = { enabled = true },
                    -- auto_show = false,
                  },
                },
                keymap = {
                    preset = "default",
                    ["<C-j>"] = { "select_next" },
                    ["<C-k>"] = { "select_prev" },
                    ['<CR>'] = { 'accept', 'fallback' },

                },
                completion = {
                    trigger = {
                        prefetch_on_insert = true,     -- Pre-fetch when entering insert mode
                        show_on_keyword = true,
                        show_on_trigger_character = true,
                        -- FASTER: Reduce debounce
                    },
                    -- Show immediately even if incomplete
                    list = {
                        selection = { preselect = true },
                    },
                     accept = {
                            -- experimental auto-brackets support
                            auto_brackets = {
                              enabled = true,
                            },
                          },
                    menu = {
                        -- scrolloff = 1,
                        -- scrollbar = false,
                        -- border = "rounded",
                        border="none",
                    },
                    ghost_text = {
                        enabled = true
                    },
                    documentation = {
                        window = {
                            border = "none",
                            desired_min_width = 30,
                        },
                        auto_show = true,
                        auto_show_delay_ms = 500,
                    },
                },

            })

            -- Load VSCode-style LuaSnip snippets after Blink is configured
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
}

