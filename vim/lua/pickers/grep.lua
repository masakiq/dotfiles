local builtin = require("telescope.builtin")
local core = require("pickers.core")

local M = {}

local function normalize_search_dirs(search_dirs)
  if not search_dirs or search_dirs == "" then
    return nil
  end

  if type(search_dirs) == "string" then
    return { search_dirs }
  end

  return search_dirs
end

local function additional_args(opts)
  return function()
    local args = {}

    if opts.fixed_strings ~= false then
      table.insert(args, "--fixed-strings")
    end

    if opts.sort == "modified" then
      table.insert(args, "--sortr")
      table.insert(args, "modified")
    elseif opts.sort == "path" then
      table.insert(args, "--sort")
      table.insert(args, "path")
    end

    return args
  end
end

function M.grep_string(opts)
  opts = opts or {}

  local picker_opts = core.with_file_mappings(core.default_picker_opts(opts))
  picker_opts.search = opts.search
  picker_opts.search_dirs = normalize_search_dirs(opts.search_dirs)
  picker_opts.additional_args = additional_args(opts)

  return builtin.grep_string(picker_opts)
end

function M.live_grep(opts)
  opts = opts or {}

  local picker_opts = core.with_file_mappings(core.default_picker_opts(opts))
  picker_opts.search_dirs = normalize_search_dirs(opts.search_dirs)
  picker_opts.additional_args = additional_args(opts)

  return builtin.live_grep(picker_opts)
end

return M
