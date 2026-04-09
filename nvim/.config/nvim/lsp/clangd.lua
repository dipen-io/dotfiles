return {
    cmd = {
        "clangd",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=never",
        "--fallback-style=llvm",
        "--query-driver=clang++",
    },
    filetypes = { "c", "cpp" },
    init_options = {
        fallbackFlags = {
            "-std=c++23",
            "-stdlib=libc++",
        },
    },
}
