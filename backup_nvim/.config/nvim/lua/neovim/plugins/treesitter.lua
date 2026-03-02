return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "vimdoc",
                "javascript",
                "go",
                "typescript",
                "c",
                "lua",
                "rust",
                "jsdoc",
                "bash",
                "html"
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

        -- Load Treesitter parsers correctly
        local ok, parsers = pcall(require, "nvim-treesitter.parsers")
        if not ok then
            vim.notify("Failed to load Treesitter parsers!", vim.log.levels.ERROR)
            return
        end

        local parser_config = parsers.get_parser_configs()
        parser_config.templ = {
            install_info = {
                url = "https://github.com/vrischmann/tree-sitter-templ.git",
                files = { "src/parser.c", "src/scanner.c" },
                branch = "master",
            },
            filetype = "templ", -- Register for correct filetype
        }

        vim.treesitter.language.register("templ", "templ")
    end
}
