local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local tab_drop_action = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)

  if selection then
    local path = selection.path or selection.filename or selection.value
    if path then
      vim.cmd("tab drop " .. path)
    end
  end
end

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-e>"] = actions.select_default,
        ["<Enter>"] = tab_drop_action,
      },
      n = {
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-e>"] = actions.select_default,
        ["<Enter>"] = tab_drop_action,
      },
    },
  },
  pickers = {
    lsp_definitions = {
      jump_type = "never",
    },
  },
})
