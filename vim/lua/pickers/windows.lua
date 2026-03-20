local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local core = require("pickers.core")
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local M = {}

function M.collect()
  local items = {}
  local current_tabpage = vim.api.nvim_get_current_tabpage()
  local current_window = vim.api.nvim_get_current_win()

  for tabnr, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    for winnr, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
      local bufnr = vim.api.nvim_win_get_buf(win)
      local name = vim.api.nvim_buf_get_name(bufnr)

      table.insert(items, {
        tabpage = tabpage,
        tabnr = tabnr,
        win = win,
        winnr = winnr,
        bufnr = bufnr,
        path = name ~= "" and name or nil,
        label = name ~= "" and vim.fn.fnamemodify(name, ":.") or "[No Name]",
        modified = vim.bo[bufnr].modified,
        is_current = tabpage == current_tabpage and win == current_window,
      })
    end
  end

  return items
end

function M.jump(item)
  vim.api.nvim_set_current_tabpage(item.tabpage)
  vim.api.nvim_set_current_win(item.win)
end

function M.pick(opts)
  opts = core.default_picker_opts(opts)

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 1 },
      { width = 4 },
      { width = 4 },
      { remaining = true },
    },
  })

  local function jump_action(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    if selection and selection.value then
      M.jump(selection.value)
    end
  end

  pickers.new(opts, {
    prompt_title = opts.prompt_title or "Windows",
    finder = finders.new_table({
      results = M.collect(),
      entry_maker = function(item)
        return {
          value = item,
          ordinal = string.format("%d %d %s", item.tabnr, item.winnr, item.label),
          display = function(entry)
            local value = entry.value
            local modified = value.modified and " [+]" or ""
            return displayer({
              { value.is_current and ">" or " " },
              { string.format("%3d", value.tabnr), "Number" },
              { string.format("%3d", value.winnr), "String" },
              value.label .. modified,
            })
          end,
          filename = item.path,
          path = item.path,
        }
      end,
    }),
    previewer = conf.file_previewer(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = core.chain_attach_mappings(function(prompt_bufnr, map)
      for _, mode in ipairs({ "i", "n" }) do
        map(mode, "<CR>", jump_action)
        map(mode, "<C-e>", jump_action)
        map(mode, "?", action_layout.toggle_preview)
        map(mode, "<C-n>", actions.preview_scrolling_down)
        map(mode, "<C-p>", actions.preview_scrolling_up)
      end

      return true
    end, opts.attach_mappings),
  }):find()
end

return M
