local builtin = require("telescope.builtin")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
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

function M.build_rg_file_command(opts)
  opts = opts or {}

  local command = {
    "rg",
    "--hidden",
    "--files",
    "--glob",
    "!**/.git/**",
  }

  if opts.include_ignored then
    table.insert(command, "--no-ignore")
  end

  if opts.sort == "modified" then
    table.insert(command, "--sortr")
    table.insert(command, "modified")
  elseif opts.sort == "path" then
    table.insert(command, "--sort")
    table.insert(command, "path")
  end

  for _, dir in ipairs(normalize_search_dirs(opts.search_dirs) or {}) do
    table.insert(command, dir)
  end

  return command
end

function M.find_files(opts)
  opts = core.with_file_mappings(core.default_picker_opts(opts))
  opts.hidden = opts.hidden ~= false
  if opts.follow == nil then
    opts.follow = false
  end

  return builtin.find_files(opts)
end

function M.rg_files(opts)
  opts = core.with_file_mappings(core.default_picker_opts(opts))

  pickers.new(opts, {
    prompt_title = opts.prompt_title or "Files",
    finder = finders.new_oneshot_job(M.build_rg_file_command(opts), {
      cwd = opts.cwd,
    }),
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end

return M
