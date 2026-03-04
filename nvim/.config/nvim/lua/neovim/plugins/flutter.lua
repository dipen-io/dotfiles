return {
  'akinsho/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    
    require('flutter-tools').setup {
      flutter_path = vim.fn.expand("~/mob_dev/flutter/bin/flutter"),
      lsp = {
        capabilities = capabilities,
        -- Explicit Dart SDK path
        cmd = {
          vim.fn.expand("~/mob_dev/flutter/bin/cache/dart-sdk/bin/dart"),
          "language-server",
          "--protocol=lsp"
        },
      },
    }
  end,
}
