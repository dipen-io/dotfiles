-- require("neovim.plugins.treesitter")
require("nvim-treesitter.config").setup({
  compilers = { "gcc", "cc" },
    ensure_installed = {
        "vimdoc",
        "javascript",
        "typescript",
        "c",
        "lua",
        "bash",
        "html",
        "php"
    },

    sync_install = false,
    auto_install = true,

    indent = { enable = true },

    highlight = {
        enable = true, -- Enables syntax highlighting
        disable = function(lang, buf)
            if lang == "html" then
                print("disabled")
                return true
            end

            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                vim.notify(
                    "File larger than 100KB, Treesitter disabled for performance",
                    vim.log.levels.WARN,
                    { title = "Treesitter" }
                )
                return true
            end
        end,

        additional_vim_regex_highlighting = { "markdown" },
    },
})
