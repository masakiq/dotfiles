local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local tab_drop_action = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)

  if selection then
    local filepath = selection.filename
    local lnum = selection.lnum
    local col = selection.col

    if filepath then
      vim.cmd("tab drop " .. filepath)
      if lnum and col then
        vim.api.nvim_win_set_cursor(0, { lnum, col })
      end
    end
  end
end

require("telescope").setup({
  defaults = {
    layout_strategy = "vertical",
    sorting_strategy = "ascending",
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
    layout_config = {
      vertical = {
        height = 0.9,
        preview_cutoff = 0,
        prompt_position = "top",
        mirror = true,
        width = 0.9,
        preview_height = 0.5,
        results_title = false,
      },
    },
  },
  pickers = {
    lsp_definitions = {
      jump_type = "never",
    },
  },
})
