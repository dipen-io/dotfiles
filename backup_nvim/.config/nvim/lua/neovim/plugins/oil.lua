vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil",
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})

return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup {
                columns = { "icon" },
                opts = {
                    columns = {
                        "icon",
                    },
                    win_options = {
                        signcolumn = "auto",
                    },
                    lsp_file_methods = {
                        autosave_changes = true,
                    },
                    view_options = {
                        show_hidden = false,
                        natural_order = true,
                    },
                    float = {
                        max_height = 20,
                        max_width = 60,
                    },
                },
                keymaps = {
                    ["<C-h>"] = false,
                    ["<C-l>"] = false,
                    ["<C-k>"] = false,
                    ["<C-j>"] = false,
                    ["<M-h>"] = "actions.select_split",
                },
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name, _)
                        local folder_skip = { "dev-tools.locks", "dune.lock", "_build" }
                        return vim.tbl_contains(folder_skip, name)
                    end,
                },

                float = {
                    max_width = 80,
                    max_height = 20,
                },

            }

            -- Open parent directory in current window
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

            -- Open parent directory in floating window
            vim.keymap.set("n", "<leader>pf", require("oil").toggle_float)
        end,
    },
}
