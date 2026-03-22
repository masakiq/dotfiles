local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local core = require("pickers.core")
local finders = require("telescope.finders")
local normal_registry = require("selectors.normal")
local pickers = require("telescope.pickers")
local visual_registry = require("selectors.visual")

local M = {}

local function normalize_context(context)
  if context.start_line > context.end_line then
    context.start_line, context.end_line = context.end_line, context.start_line
    context.start_col, context.end_col = context.end_col, context.start_col
  elseif context.start_line == context.end_line and context.start_col > context.end_col then
    context.start_col, context.end_col = context.end_col, context.start_col
  end

  return context
end

local function text_from_context(context)
  local lines = vim.api.nvim_buf_get_lines(context.bufnr, context.start_line - 1, context.end_line, false)
  if #lines == 0 then
    return ""
  end

  if context.visual_mode == "V" then
    return table.concat(lines, "\n")
  end

  lines[#lines] = string.sub(lines[#lines], 1, context.end_col)
  lines[1] = string.sub(lines[1], context.start_col)

  return table.concat(lines, "\n")
end

local function available_entries(entries)
  return vim.tbl_filter(function(entry)
    if entry.command then
      return vim.fn.exists(":" .. entry.command) == 2
    end

    return type(entry.callback) == "function"
  end, entries)
end

local function restore_visual_context(context)
  if not context then
    return
  end

  if context.winid and vim.api.nvim_win_is_valid(context.winid) then
    vim.api.nvim_set_current_win(context.winid)
  elseif context.bufnr and vim.api.nvim_buf_is_valid(context.bufnr) then
    vim.cmd("buffer " .. context.bufnr)
  end

  if context.start_line and context.end_line then
    vim.fn.setpos("'<", { 0, context.start_line, context.start_col, 0 })
    vim.fn.setpos("'>", { 0, context.end_line, context.end_col, 0 })
  end
end

local function run_entry(entry, context)
  restore_visual_context(context)

  if entry.callback then
    entry.callback(context)
    return
  end

  if entry.command then
    vim.cmd(entry.command)
  end
end

local function format_entry(entry)
  return entry.label
end

local function open_picker(title, entries, context)
  local picker_opts = core.default_picker_opts({
    prompt_title = title,
    previewer = false,
    attach_mappings = function(prompt_bufnr, map)
      local function select_entry()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection and selection.value then
          vim.schedule(function()
            run_entry(selection.value, context)
          end)
        end
      end

      for _, mode in ipairs({ "i", "n" }) do
        map(mode, "<CR>", select_entry)
        map(mode, "<C-e>", select_entry)
      end

      return true
    end,
  })

  pickers
    .new(picker_opts, {
      finder = finders.new_table({
        results = available_entries(entries),
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.label,
            ordinal = entry.label,
          }
        end,
      }),
      previewer = false,
      sorter = conf.generic_sorter(picker_opts),
    })
    :find()
end

local function open_ui_select(title, entries, context)
  vim.ui.select(available_entries(entries), {
    prompt = title,
    format_item = format_entry,
  }, function(choice)
    if not choice then
      return
    end

    vim.schedule(function()
      run_entry(choice, context)
    end)
  end)
end

local function visual_context()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local context = {
    bufnr = vim.api.nvim_get_current_buf(),
    winid = vim.api.nvim_get_current_win(),
    start_line = start_pos[2],
    start_col = start_pos[3],
    end_line = end_pos[2],
    end_col = end_pos[3],
    visual_mode = vim.fn.visualmode(),
  }

  context = normalize_context(context)
  context.text = text_from_context(context)
  return context
end

function M.capture_active_visual_context()
  local anchor = vim.fn.getpos("v")
  local cursor = vim.api.nvim_win_get_cursor(0)

  local context = {
    bufnr = vim.api.nvim_get_current_buf(),
    winid = vim.api.nvim_get_current_win(),
    start_line = anchor[2],
    start_col = anchor[3],
    end_line = cursor[1],
    end_col = cursor[2] + 1,
    visual_mode = vim.fn.mode(),
  }

  context = normalize_context(context)
  context.text = text_from_context(context)
  return context
end

function M.select_function()
  open_picker("Function", normal_registry.entries)
end

function M.select_visual_function(context)
  context = context or visual_context()
  if context.start_line == 0 or context.end_line == 0 then
    vim.notify("No visual selection found.", vim.log.levels.WARN)
    return
  end

  open_ui_select("Function", visual_registry.entries, context)
end

return M
