-- Configuration for zbirenbaum/copilot.lua
-- This file contains the setup for the copilot plugin

-- Check if the plugin is installed
local ok, copilot = pcall(require, "copilot")
if not ok then
  return
end

-- Setup copilot with your desired configuration
copilot.setup({
  panel = {
    enabled = true,
    auto_refresh = true,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-Tab>",
    },
    layout = {
      position = "right", -- | top | bottom | left | right
      ratio = 0.5,
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = true,
    debounce = 75,
    keymap = {
      accept = "<Tab>",
      -- accept_word = "<M-w>",
      -- accept_line = "<M-L>",
      next = "<C-n>",
      prev = "<C-p>",
      dismiss = "<esc>",
    },
  },
  filetypes = {
    -- yaml = false,
    -- markdown = false,
    -- help = false,
    -- gitcommit = false,
    -- gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    [".env"] = false,
    ["."] = false,
  },
  copilot_node_command = "node",
  server_opts_overrides = {},
})
