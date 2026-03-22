-- 1. Plugin Manager Setup
require("neovim.lazy")

-- 2. Load Configurations
-- Note: Order matters! Load settings/keymaps before LSPs usually.
require("neovim.core.settings")
require("neovim.core.keymaps")
require("neovim.core.autocmd")
require("neovim.core.statusline")

-- 3. Load LSP Config
require("neovim.plugins.lsp")


-- 4. Additional setup
vim.filetype.add({
  filename = {
    ['init'] = 'sh',
    ['sxhkdrc'] = 'sxhkdrc',
  },
  pattern = {
    ['.*/river/init'] = 'sh',
  },
})

-- Function to clear backgrounds
local function clear_diagnostic_bg()
    local groups = {
        "DiagnosticSignError",
        "DiagnosticSignWarn",
        "DiagnosticSignInfo",
        "DiagnosticSignHint",
        "SignColumn", -- This is the gutter itself
    }

    for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
    end
end

-- Run it immediately
clear_diagnostic_bg()

-- Run it again whenever the colorscheme changes (some themes override settings)
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = clear_diagnostic_bg,
})

-- for just removing the nodejs comoonjs warning
vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
  if result and result.diagnostics then
    result.diagnostics = vim.tbl_filter(function(d)
      return d.code ~= 80001
    end, result.diagnostics)
  end
  vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
end
