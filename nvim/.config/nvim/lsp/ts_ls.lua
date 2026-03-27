local blink = require("blink.cmp")

return {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "astro",
    },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = 'none',        -- CHANGE: 'none' instead of 'all'
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,    -- keep type hints
                includeInlayVariableTypeHints = true,             -- keep variable types
                includeInlayFunctionLikeReturnTypeHints = true,
            },

            typescript = {
                tsserver = {
                    useSyntaxServer = "auto",
                    -- SPEED UP: Limit type checking
                    maxTsServerMemory = 8192,  -- Increase memory (MB)
                    -- Disable slow features
                    disableAutomaticTypingAcquisition = false,
                },
                preferences = {
                    -- Skip deep type analysis for faster completion
                    includePackageJsonAutoImports = "auto",
                },
            },
        },
    },
    capabilities = blink.get_lsp_capabilities(), -- SIMPLIFIED
}
