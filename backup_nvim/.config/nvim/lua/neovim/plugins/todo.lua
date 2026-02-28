return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
    },
    --need some remap here for seraching TODO: list
    --NOTE:
    vim.keymap.set('n', "<leader>tt", "<cmd>TodoTelescope<cr>"),
    vim.keymap.set('n', "<leader>th", "<cmd>TodoQuickFix<cr>")
}
