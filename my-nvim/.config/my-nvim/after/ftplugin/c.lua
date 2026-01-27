
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.wrap = false
vim.opt.textwidth = 0
local map = vim.keymap.set

-- automatically close quotes, parenthesis, and brackets
map("i", "'", "''<left>")
map("i", "\"", "\"\"<left>")
map("i", "(", "()<left>")
map("i", "[", "[]<left>")
map("i", "{", "{}<left>")
map("i", "{;", "{};<left><left>")
map("i", "/*", "/**/<left><left>")

--comment out lines in C
map("n", "<leader>cl", "I/*<ESC>A*/<ESC>")
map("n", "<leader>uc", "0d2lA<left><ESC>d$<ESC>")

-- automatically type out include lines
map("n", "<leader>in", "I#include <><left>")

