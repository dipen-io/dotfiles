
local blink = require("blink.cmp")
return {
    cmd = { "eslint", "eslint_d" },
    filetypes = {
        "html",
        "astro",
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
}
