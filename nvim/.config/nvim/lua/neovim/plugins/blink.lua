-- lazydev setup (was ft = "lua" in lazy, use autocmd instead)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    require("lazydev").setup({
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    })
  end,
})

-- load snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- blink setup (paste your exact config, just remove the outer return/config wrapper)
require("blink.cmp").setup({
  fuzzy = {
    implementation = "lua",  -- use lua instead of prebuilt rust binary
  },

  snippets = { preset = "luasnip" },
  signature = {
    enabled = true,
    trigger = {
      enabled = true,
      show_on_insert = true,
      show_on_trigger_character = true,
    },
    window = { border = "rounded" },
  },
  appearance = {
    nerd_font_variant = "normal",
  },
  sources = {
    default = { "lsp", "path", "snippets", "lazydev", "buffer" },
    providers = {
      lsp = {
        async = true,
        timeout_ms = 100,
        score_offset = 4,
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },
  cmdline = {
    enabled = true,
    keymap = {
      preset = "cmdline",
      ["<Right>"] = { "fallback" },
      ["<Left>"] = { "fallback" },
    },
    completion = {
      list = { selection = { preselect = false } },
      menu = {
        auto_show = function(ctx)
          return vim.fn.getcmdtype() == ":"
        end,
      },
      ghost_text = { enabled = true },
    },
  },
  keymap = {
    preset = "default",
    ["<C-j>"] = { "select_next" },
    ["<C-k>"] = { "select_prev" },
    ["<CR>"] = { "accept", "fallback" },
  },
  completion = {
    trigger = {
      prefetch_on_insert = true,
      show_on_keyword = true,
      show_on_trigger_character = true,
    },
    list = {
      selection = { preselect = true },
    },
    accept = {
      auto_brackets = { enabled = true },
    },
    menu = { border = "none" },
    ghost_text = { enabled = true },
    documentation = {
      window = {
        border = "none",
        desired_min_width = 30,
      },
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
})
