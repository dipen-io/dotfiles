-- return {
--     cmd = { "zls" },  -- or "/usr/local/bin/zls" if needed
--     filetypes = { "zig" },
--
--     root_dir = function()
--         return vim.fs.dirname(
--             vim.fs.find({ "zls.json", "build.zig", "zig.mod", ".git" }, { upward = true })[1]
--         )
--     end,
--
--     settings = {
--         zls = {
--             zig_exe_path = "/usr/local/bin/zig", -- fix your error
--             enable_autofix = true,
--             enable_snippets = true,
--             warn_style = true,
--         },
--     },
-- }

return {
    cmd = { "zls" }, -- or absolute path if needed: "/usr/bin/zls"
    filetypes = { "zig" },
    root_dir = vim.fs.dirname(vim.fs.find({ "zls.json", "build.zig", "zig.mod" }, { upward = true })[1]),
}

