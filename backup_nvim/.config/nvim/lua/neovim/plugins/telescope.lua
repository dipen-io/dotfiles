return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },

    config = function()
        local telescope = require("telescope")
        local builtin = require('telescope.builtin')
        local actions = require("telescope.actions")

        -- this is the setup i made lets see works or not
        telescope.setup({
            theme = 'ivy',
            -- pickers = {
            --     colorscheme = {
            --         enable_preview = true,
            --     },
            --     find_files = {
            --         theme = 'ivy'
            --     },
            --     buffers = {
            --         theme = 'ivy'
            --     },
            -- },
            extensions = {
                fzf = {}
            },
            defaults = {
                -- Appearance
                entry_prefix = '󱞩 ',
                prompt_prefix = ' ',
                selection_caret = '󰞘 ',
                color_devicons = true,
                path_display = {
                    shorten = {
                        len = 1,
                        exclude = { -1, -2 },
                    },
                    'truncate',
                },

                -- Searching
                set_env = { COLORTERM = 'truecolor' },
                file_ignore_patterns = {
                    '.git/',
                    'node_modules',
                    '%.jpg',
                    '%.jpeg',
                    '%.png',
                    '%.svg',
                    '%.otf',
                    '%.ttf',
                    '%.lock',
                    '__pycache__',
                    '%.sqlite3',
                    '%.ipynb',
                    'target',
                    'build',
                    'vendor',
                    'node_modules',
                    'dotbot',
                    'packer_compiled.lua',
                },
                -- borderchars = { "█", " ", "▀", "█", "█", " ", " ", "▀" },
                mappings = {
                    i = {
                        ["<C-l>"] = actions.smart_send_to_qflist + actions.open_qflist,
                        ['<C-q>'] = require('telescope.actions').send_to_qflist,
                    },
                },
            },
        })


        -- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
        -- vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})

        -- vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help Tags" })
        -- vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find Symbols" })
        -- vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })

        vim.keymap.set("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
        vim.keymap.set("n", "<leader>ps", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
        vim.keymap.set("n", "<space>fg", require "neovim.plugins.telescope.multi_grep")
        --This is shit userfull
        vim.keymap.set(
            "n",
            "<leader>pw",
            builtin.current_buffer_fuzzy_find,
            -- { desc = "Find string under cursor in cwd" }
            { desc = "Find string in current buffer" }
        )


        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)

        vim.keymap.set(
            "n",
            "<leader>fa",
            "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>",
            { desc = "Find all" }
        )
    end
}
