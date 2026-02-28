function ColorMyPencils(color)
    color = color or "rose-pine-moon"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

function ColorMyAustere()
    vim.opt.background = "dark"
    vim.opt.termguicolors = true
    vim.cmd.colorscheme("austere")

    vim.api.nvim_set_hl(0, "Constant", { fg = "#ce5252" })
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#252525" })
end

function ColorMyBreakingBad()
    vim.opt.background = "dark"
    vim.opt.termguicolors = true
    vim.cmd.colorscheme("breakingbad")

    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#404040" })
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

function ColorMyGruvbox()
    vim.opt.background = "dark"
    vim.opt.termguicolors = true
    vim.cmd.colorscheme("gruvbox")

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

function ColorMyRosePine()
    vim.opt.background = "dark"
    vim.opt.termguicolors = true
    vim.cmd.colorscheme("rose-pine")

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

function ColorMyGruber()
    vim.opt.background = "dark"
    vim.opt.termguicolors = true
    vim.cmd.colorscheme("gruber-darker")

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
end

return {

    {
        "vague2k/vague.nvim",
        config = function()
            require("vague").setup({
                transparent = true,
                style = {
                    -- "none" is the same thing as default. But "italic" and "bold" are also valid options
                    boolean = "none",
                    number = "none",
                    float = "bold",
                    error = "bold",
                    comments = "italic",
                    conditionals = "bold",
                    functions = "bold",
                    headings = "bold",
                    operators = "bold",
                    strings = "bold",
                    variables = "bold",

                    -- keywords
                    keywords = "italic",
                    keyword_return = "italic",
                    keywords_loop = "italic",
                    keywords_label = "italic",
                    keywords_exception = "italic",

                    -- builtin
                    builtin_constants = "none",
                    builtin_functions = "none",
                    builtin_types = "none",
                    builtin_variables = "none",
                },
            })
            -- vim.cmd.colorscheme("vague")
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                dim_inactive_windows = false,
                extend_background_behind_borders = true,
                styles = {
                    italic = true,
                    transparency = true,
                },
            })

            -- ColorMyPencils();
        end
    },
    { "rose-pine/neovim",      name = "rose-pine" },
    { "morhetz/gruvbox",       name = "gruvbox" },
    { "folke/tokyonight.nvim", name = "tokyonight" },
    { "w0ng/vim-hybrid",       name = "hybrid" },
    -- "i3d/vim-jimbothemes",
    "chrisbra/Colorizer",
    "lurst/austere.vim",
    { "blazkowolf/gruber-darker.nvim", name = "gruber-darker", config = ColorMyGruber },

}
