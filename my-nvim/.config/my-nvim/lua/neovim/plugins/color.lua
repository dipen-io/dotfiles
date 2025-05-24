function ColorMyGruber()
    vim.opt.background = "dark"
    vim.opt.termguicolors = true
    vim.cmd.colorscheme("gruber-darker")

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    -- !! Fix window color !!
    vim.api.nvim_set_hl(0, "WinBar", { bg = "none" })
    vim.api.nvim_set_hl(0, "WinBarNC", { bg = "none" })

    -- vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
    
  -- Transparent statusline, only set foreground colors
  -- Solid background for statusline
    vim.api.nvim_set_hl(0, "StatusLine",   { fg = "#ffffff", bg = "#202020", bold = true })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#808080", bg = "#202020" })
    vim.api.nvim_set_hl(0, "CurrentBuffer", { fg = "#FFFF00", bg = "#202020", italic = true })
end

return {
    {
        "blazkowolf/gruber-darker.nvim",
        name = "gruber-darker",
        config = ColorMyGruber
    }
}
