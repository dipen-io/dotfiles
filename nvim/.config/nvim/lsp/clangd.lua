local blink = require("blink.cmp")

return {
    cmd = {
        "clangd",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=never",
        "--fallback-style=llvm",
        "--query-driver=clang++",
        "--function-arg-placeholders=false",
    },
    filetypes = { "c", "cpp" },
    -- init_options = {
    --     fallbackFlags = {
    --         "-std=c++23",
    --         "-stdlib=libc++",
    --     },
    -- },
}
