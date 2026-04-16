-- {
    --   "sainnhe/gruvbox-material",
    --   lazy = false,
    --   priority = 1000,
    --   config = function()
        --     vim.g.gruvbox_material_transparent_background = 1
        --     vim.g.gruvbox_material_foreground = "mix"
        --     vim.g.gruvbox_material_background = "hard"
        --     vim.g.gruvbox_material_ui_contrast = "high"
        --     vim.g.gruvbox_material_float_style = "bright"
        --     vim.g.gruvbox_material_statusline_style = "mix"
        --     vim.g.gruvbox_material_cursor = "auto"
        --
        --     -- UI Overrides
        --     local hl = vim.api.nvim_set_hl
        --     hl(0, "NormalFloat", { link = "Normal" })
        --     hl(0, "FloatBorder", { fg = "NONE", bg = "NONE" })
        --     hl(0, "Pmenu", { link = "Normal" })
        --     hl(0, "PmenuSel", { link = "Visual" })
        --     -- Plugin Borders
        --     hl(0, "BlinkCmpBorder", { fg = "NONE", bg = "NONE" })
        --     hl(0, "SnacksBorder", { fg = "NONE", bg = "NONE" })
        --   end,
        -- },

        -- {
            --   "adibhanna/forest-night.nvim",
            --   priority = 1000,
            --   config = function()
                --     vim.cmd("colorscheme forest-night")
                --     -- Global Transparency Overrides
                --     local groups = {
                    --       "Normal", "NormalNC", "NormalFloat", "FloatBorder",
                    --       "SignColumn", "FoldColumn", "LineNr", "CursorLineNr",
                    --       "StatusLine", "EndOfBuffer"
                    --     }
                    --     for _, group in ipairs(groups) do
                    --       vim.api.nvim_set_hl(0, group, { bg = "NONE" })
                    --     end
                    --   end,
                    -- },

                    require("catppuccin").setup({
                        -- background = { light = "latte", dark = "mocha" },
                        -- vim.cmd("colorscheme catppuccin-frappe"),
                        -- Gruvbox-inspired palette overrides
                        color_overrides = {
                            mocha = {
                                base = "#1d2021",
                                mantle = "#191b1c",
                                crust = "#141617",
                                text = "#ebdbb2",
                                green = "#a9b665",
                                teal = "#89b482",
                                peach = "#e78a4e",
                                flamingo = "#ea6962",
                            },
                        },
                        transparent_background = true,
                        show_end_of_buffer = false,
                        no_bold = true,
                        no_italic = true,
                        integrations = {
                            blink_cmp = { style = "bordered" },
                            snacks = { enabled = true },
                            gitsigns = true,
                            native_lsp = { enabled = true, inlay_hints = { background = true } },
                            treesitter = true,
                            treesitter_context = true,
                            which_key = true,
                            fidget = true,
                        },
                        highlight_overrides = {
                            all = function(colors)
                                return {
                                    -- Float and Menu Transparency
                                    Pmenu = { bg = "NONE", fg = colors.text },
                                    NormalFloat = { bg = "NONE" },
                                    FloatBorder = { bg = "NONE", fg = colors.surface2 },

                                    -- Snacks Picker
                                    SnacksPicker = { bg = "NONE" },
                                    SnacksPickerList = { bg = "NONE" },

                                    -- Clean up Blink flavors
                                    BlinkCmpMenu = { bg = "NONE" },
                                    BlinkCmpDoc = { bg = "NONE" },
                                }
                            end,
                        },
                    })

                    -- require("ember").setup({
                    --     variant = "ember", -- "ember", "ember-soft", "ember-light"
                    --     styles = {
                    --         comments  = { italic = true },
                    --         keywords  = { bold = true },
                    --         functions = {},
                    --         types     = { bold = true },
                    --     },
                    --     transparent        = true, -- transparent editor background
                    --     transparent_floats = nil,   -- follows `transparent` by default; set explicitly to override
                    --     on_colors     = nil, -- function(palette) - modify palette before theme builds
                    --         on_highlights = nil, -- function(highlights, theme) - modify highlight groups
                    --         })

