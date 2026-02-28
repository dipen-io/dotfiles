return {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 100,
    -- event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",       -- source for text in buffer
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-path",         -- source for file system paths
        "saadparwaiz1/cmp_luasnip", -- for autocompletion
    },
    config = function()
        local cmp = require("cmp")
        -- local luasnip = require("luasnip")
        -- local lspkind = require("lspkind")
        -- require("luasnip.loaders.from_vscode").lazy_load()

        -- / cmdline setup.
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        -- : cmdline setup.
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                {
                    name = "cmdline",
                    option = {
                        ignore_cmds = { "Man", "!" },
                    },
                },
            }),
        })
    end,
}
