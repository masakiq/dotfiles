local core = require("pickers.core")

require("telescope").setup({
  defaults = core.default_config(),
  pickers = {
    lsp_definitions = {
      jump_type = "never",
    },
  },
})

core.apply_highlights()
