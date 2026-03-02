return {
    cmd = { "zls" },     -- or absolute path if needed: "/usr/bin/zls"
    filetypes = { "zig" },
    root_dir = vim.fs.dirname(vim.fs.find({ "zls.json", "build.zig", "zig.mod" }, { upward = true })[1]),
    settings = {
        zig_exe_path = "zig",
    },
}
