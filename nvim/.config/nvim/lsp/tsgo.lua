local root_files = {
  "tsconfig.base.json",
  "tsconfig.json",
  "jsconfig.json",
  "package.json",
  ".git"
}

-- Search for the project root
local paths = vim.fs.find(root_files, {
  upward = true,
  stop = vim.env.HOME,
  path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) 
})

-- If no root is found, don't start the LSP
if #paths == 0 then
  return
end

---@type vim.lsp.Config
local M = {
  -- Because of Mason, you don't need the full path
  cmd = { "tsgo", "lsp", "--stdio" },

  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  },
  root_dir = vim.fs.dirname(paths[1])
}

return M
