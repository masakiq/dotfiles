local core = require("pickers.core")
local actions = require("telescope.actions")
local telescope = require("telescope")
local themes = require("telescope.themes")

telescope.setup({
  defaults = core.default_config(),
  pickers = {
    lsp_definitions = {
      jump_type = "never",
    },
  },
  extensions = {
    ["ui-select"] = themes.get_cursor({
      layout_config = {
        width = 100,
        height = 10,
      },
      mappings = {
        i = {
          ["<CR>"] = actions.select_default,
        },
        n = {
          ["<CR>"] = actions.select_default,
        },
      },
    }),
  },
})

pcall(telescope.load_extension, "ui-select")

core.apply_highlights()
