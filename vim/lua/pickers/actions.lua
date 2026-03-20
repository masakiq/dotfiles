local builtin_actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

local function resolve_value(entry, key)
  if not entry then
    return nil
  end

  if entry[key] ~= nil then
    return entry[key]
  end

  if type(entry.value) == "table" then
    return entry.value[key]
  end

  return nil
end

local function resolve_path(entry)
  local path = resolve_value(entry, "path") or resolve_value(entry, "filename")
  if path and path ~= "" then
    return path
  end

  if type(entry and entry.value) == "string" and entry.value ~= "" then
    return entry.value
  end

  local bufnr = resolve_value(entry, "bufnr")
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name ~= "" then
      return name
    end
  end

  return nil
end

local function resolve_text(entry)
  return resolve_value(entry, "text") or resolve_value(entry, "display") or entry.ordinal
end

local function move_to_entry_location(entry)
  local lnum = resolve_value(entry, "lnum")
  local col = resolve_value(entry, "col")

  if not lnum then
    return
  end

  pcall(vim.api.nvim_win_set_cursor, 0, { lnum, col or 0 })
  pcall(vim.cmd, "normal! zz")
end

function M.collect_selected_entries(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local entries = picker:get_multi_selection()

  if #entries == 0 then
    local selection = action_state.get_selected_entry()
    if selection then
      return { selection }
    end
  end

  return entries
end

function M.open_entry(command, entry)
  local path = resolve_path(entry)
  if not path then
    return false
  end

  vim.cmd(string.format("%s %s", command, vim.fn.fnameescape(path)))
  move_to_entry_location(entry)
  return true
end

function M.to_qflist_item(entry)
  local path = resolve_path(entry)
  if not path then
    return nil
  end

  local item = {
    filename = path,
  }

  local lnum = resolve_value(entry, "lnum")
  local col = resolve_value(entry, "col")
  local text = resolve_text(entry)

  if lnum then
    item.lnum = lnum
  end
  if col then
    item.col = col
  end
  if text then
    item.text = text
  end

  return item
end

function M.send_to_qflist(entries, opts)
  local items = {}

  for _, entry in ipairs(entries) do
    local item = M.to_qflist_item(entry)
    if item then
      table.insert(items, item)
    end
  end

  if #items == 0 then
    return 0
  end

  vim.fn.setqflist({}, " ", {
    title = opts and opts.title or "Telescope",
    items = items,
  })

  if not opts or opts.open ~= false then
    vim.cmd("copen")
    vim.cmd("wincmd p")
  end

  return #items
end

function M.select_tab_drop(prompt_bufnr)
  builtin_actions.close(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  if selection then
    M.open_entry("tab drop", selection)
  end
end

function M.open_with(command)
  return function(prompt_bufnr)
    builtin_actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    if selection then
      M.open_entry(command, selection)
    end
  end
end

function M.open_all_with(command)
  return function(prompt_bufnr)
    local entries = M.collect_selected_entries(prompt_bufnr)
    builtin_actions.close(prompt_bufnr)

    for _, entry in ipairs(entries) do
      M.open_entry(command, entry)
    end
  end
end

function M.open_first_and_send_to_qflist(command, opts)
  return function(prompt_bufnr)
    local entries = M.collect_selected_entries(prompt_bufnr)
    builtin_actions.close(prompt_bufnr)

    if #entries == 0 then
      return
    end

    M.open_entry(command, entries[1])
    if #entries > 1 then
      M.send_to_qflist(entries, opts)
    end
  end
end

return M
