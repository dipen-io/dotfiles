return {

    --Using nice undo tree -->
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
    { "github/copilot.vim" },
    {
        "daodejing/tabber.nvim",
        config = true,
    },
    { "m-demare/hlargs.nvim" },

    --helps in lsp refernces
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
    },

    --for rust
    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false,   -- This plugin is already lazy
    },                  --For auto pairs -->
    {
        'rust-lang/rust.vim',
        ft = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },

    --This is required by other plugins -->
    {
        "nvim-lua/plenary.nvim",
        build = ":TSUpdate",
        name = "plenary"
    },

    -- MarkdownPreview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    -- Hightlight cursor -->
    {
        "RRethy/vim-illuminate",
        config = function()
            require("illuminate")
        end,
    },

    -- Show key in screen -->
    -- {
    --     "NStefan002/screenkey.nvim",
    --     lazy = false,
    --     version = "*", -- or branch = "dev", to use the latest commit
    -- },
    {
        "nvzone/showkeys",
        cmd = "ShowkeysToggle",
        opts = {
            timeout = 1,
            maxkeys = 5,
            -- more opts
        }
    },
    {
        "nvim-tree/nvim-web-devicons",
        config = function()
        end
    },
    -- {
    --     "ibhagwan/fzf-lua",
    --     -- optional for icon support
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    --     opts = {}
    -- },
    { "junegunn/fzf", build = "./install --all" },

    -- This is my be replacement of which key
    {
        "tummetott/unimpaired.nvim",
        config = function()
            require("unimpaired").setup()
        end,
    },
    -- for auto tags
    {
        "windwp/nvim-ts-autotag",
        lazy = false,
        config = {},
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    --nice command prompt --
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        config = function()
            require("noice").setup({

                cmdline = {
                    format = {
                        search_down = {
                            view = "cmdline",
                            icon = "",
                        },
                    },
                },
                -- for search bar
                routes = {
                    {
                        filter = {
                            event = "msg_show",
                            kind = "search_count",
                        },
                        opts = { skip = true },
                    },
                },
                --for cmd-line
                views = {
                    cmdline_popup = {
                        border = {
                            style = "none",
                            padding = { 2, 3 },
                        },
                        filter_options = {},
                        win_options = {
                            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                        },
                    },
                },
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                    },
                    progress = {
                        enabled = false, --disable  lsp message when first load
                    },
                },
                presets = {
                    bottom_search = false,         -- use a classic bottom cmdline for search
                    command_palette = false,       --set true to top
                    long_message_to_split = false, -- long messages will be sent to a split
                    inc_rename = false,            -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true,         -- add a border to hover docs and signature help
                },
            })
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },

    --for smooth scrolling
    -- {
    --     "karb94/neoscroll.nvim",
    --     config = function()
    --         local neoscroll = require('neoscroll')
    --         neoscroll.setup({
    --         })
    --
    --         -- Key mappings for scrolling with neoscroll
    --         local keymap = {
    --             ["<S-c>"] = function() neoscroll.ctrl_u({ duration = 300 }) end,
    --             ["<S-m>"] = function() neoscroll.ctrl_d({ duration = 300 }) end,
    --         }
    --
    --         -- Modes to apply the mappings
    --         local modes = { 'n', 'v', 'x' }
    --
    --         -- Apply the mappings for each mode
    --         for _, mode in ipairs(modes) do
    --             for key, func in pairs(keymap) do
    --                 vim.keymap.set(mode, key, func)
    --             end
    --         end
    --     end,
    -- },
    {
        "OXY2DEV/markview.nvim",
        lazy = false
    },


    --harpoon -->
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")

            harpoon:setup()

            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end)
            vim.keymap.set("n", "<S-i>", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end)

            vim.keymap.set("n", "<leader>h", function()
                harpoon:list():select(1)
            end)
            vim.keymap.set("n", "<leader>j", function()
                harpoon:list():select(2)
            end)
            vim.keymap.set("n", "<leader>k", function()
                harpoon:list():select(3)
            end)
            vim.keymap.set("n", "<leader>i", function()
                harpoon:list():select(4)
            end)

            -- Toggle previous & next buffers stored within Harpoon list
            -- vim.keymap.set("n", "<A-i>", function()
            --     harpoon:list():prev()
            -- end)
            -- vim.keymap.set("n", "<A-o>", function()
            --     harpoon:list():next()
            -- end)
        end,
    },
}
