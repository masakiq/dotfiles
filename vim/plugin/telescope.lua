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
    layout_strategy = "horizontal",
    sorting_strategy = "ascending",
    winblend = 0,
    mappings = {
      i = {
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-e>"] = actions.select_default,
        ["<Enter>"] = tab_drop_action,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.preview_scrolling_down,
        ["<C-p>"] = actions.preview_scrolling_up,
      },
      n = {
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-e>"] = actions.select_default,
        ["<Enter>"] = tab_drop_action,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.preview_scrolling_down,
        ["<C-p>"] = actions.preview_scrolling_up,
      },
    },
    layout_config = {
      horizontal = {
        height = 0.95,
        preview_cutoff = 0,
        prompt_position = "top",
        width = 0.95,
        preview_width = 0.5,
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

vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "#000000" })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#000000" })
vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "#000000" })

vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "#000000" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "#000000" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "#000000" })
