local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local picker_actions = require("pickers.actions")

local M = {}

function M.default_config()
  return {
    layout_strategy = "horizontal",
    sorting_strategy = "ascending",
    winblend = 0,
    mappings = {
      i = {
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-e>"] = actions.select_default,
        ["<CR>"] = picker_actions.select_tab_drop,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.preview_scrolling_down,
        ["<C-p>"] = actions.preview_scrolling_up,
      },
      n = {
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-e>"] = actions.select_default,
        ["<CR>"] = picker_actions.select_tab_drop,
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
  }
end

function M.apply_highlights()
  vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "#000000" })
end

function M.default_picker_opts(opts)
  return vim.tbl_deep_extend("force", {}, {
    layout_strategy = "horizontal",
    sorting_strategy = "ascending",
    results_title = false,
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
  }, opts or {})
end

function M.chain_attach_mappings(...)
  local callbacks = { ... }

  return function(prompt_bufnr, map)
    for _, callback in ipairs(callbacks) do
      if callback then
        local ok = callback(prompt_bufnr, map)
        if ok == false then
          return false
        end
      end
    end

    return true
  end
end

function M.with_file_mappings(opts)
  opts = opts or {}

  local original_attach = opts.attach_mappings
  opts.attach_mappings = M.chain_attach_mappings(function(prompt_bufnr, map)
    for _, mode in ipairs({ "i", "n" }) do
      map(mode, "<CR>", picker_actions.select_tab_drop)
      map(mode, "<C-e>", picker_actions.open_with("edit"))
      map(mode, "<C-s>", picker_actions.open_with("split"))
      map(mode, "<C-v>", picker_actions.open_with("vsplit"))
      map(mode, "<C-x>", picker_actions.open_first_and_send_to_qflist("tab drop", {
        title = opts.prompt_title or "Telescope",
      }))
      map(mode, "<C-a>", actions.select_all)
      map(mode, "<C-u>", actions.toggle_selection)
      map(mode, "?", action_layout.toggle_preview)
      map(mode, "<C-n>", actions.preview_scrolling_down)
      map(mode, "<C-p>", actions.preview_scrolling_up)
    end

    return true
  end, original_attach)

  return opts
end

return M
