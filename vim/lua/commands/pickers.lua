local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local core = require("pickers.core")
local file_pickers = require("pickers.files")
local grep_pickers = require("pickers.grep")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local window_pickers = require("pickers.windows")

local M = {}

local function normalize_search_dirs(path)
  if not path or path == "" then
    return nil
  end

  return { vim.fn.expand(path) }
end

local function normalize_sort(sort)
  if not sort or sort == "" then
    return nil
  end

  if sort == "--sortr modified" or sort == "modified" then
    return "modified"
  end

  if sort == "--sort path" or sort == "path" then
    return "path"
  end

  return nil
end

local function legacy_file_opts(path, sort, extra)
  local normalized_path = path or ""
  local normalized_sort = sort or ""

  if normalized_path ~= "" and normalized_path:match("^%-%-") and normalized_sort == "" then
    normalized_sort = normalized_path
    normalized_path = ""
  end

  if normalized_path == "" and normalized_sort == "" and not (extra and extra.include_ignored) then
    normalized_sort = "--sortr modified"
  end

  return vim.tbl_deep_extend("force", {
    search_dirs = normalize_search_dirs(normalized_path),
    sort = normalize_sort(normalized_sort),
  }, extra or {})
end

local function with_preview_toggle(opts, callback)
  return core.chain_attach_mappings(function(prompt_bufnr, map)
    for _, mode in ipairs({ "i", "n" }) do
      map(mode, "?", action_layout.toggle_preview)
      map(mode, "<C-n>", actions.preview_scrolling_down)
      map(mode, "<C-p>", actions.preview_scrolling_up)
      if callback then
        callback(prompt_bufnr, map, mode)
      end
    end

    return true
  end, opts and opts.attach_mappings)
end

local function find_window_for_buffer(bufnr)
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
      if vim.api.nvim_win_get_buf(win) == bufnr then
        return tabpage, win
      end
    end
  end

  return nil, nil
end

local function jump_to_buffer(bufnr)
  local tabpage, win = find_window_for_buffer(bufnr)
  if tabpage and win then
    vim.api.nvim_set_current_tabpage(tabpage)
    vim.api.nvim_set_current_win(win)
    return
  end

  vim.cmd("buffer " .. bufnr)
end

local function edit_buffer(bufnr)
  vim.cmd("buffer " .. bufnr)
end

local function split_buffer(bufnr)
  vim.cmd("split")
  vim.cmd("buffer " .. bufnr)
end

local function vsplit_buffer(bufnr)
  vim.cmd("vsplit")
  vim.cmd("buffer " .. bufnr)
end

local function open_buffer_picker(command)
  return function(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)

    if not selection or not selection.bufnr then
      return
    end

    command(selection.bufnr)
  end
end

local function wipe_all_buffers()
  for _, info in ipairs(vim.fn.getbufinfo()) do
    pcall(vim.cmd, "bwipeout! " .. info.bufnr)
  end
end

local function set_title()
  local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  local branch = ""
  local result = vim.fn.systemlist({ "git", "rev-parse", "--abbrev-ref", "HEAD" })
  if vim.v.shell_error == 0 and result[1] then
    branch = result[1]
  end

  vim.o.titlestring = dir .. "---" .. branch
end

local function preview_project_readme()
  return previewers.new_buffer_previewer({
    title = "README",
    define_preview = function(self, entry, status)
      local project = entry.value
      local candidates = {
        project .. "/README.md",
        project .. "/README",
        project .. "/readme.md",
      }

      for _, candidate in ipairs(candidates) do
        if vim.fn.filereadable(candidate) == 1 then
          conf.buffer_previewer_maker(candidate, self.state.bufnr, {
            bufname = self.state.bufname,
            winid = status.preview_win,
          })
          return
        end
      end

      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {
        "README.md not found",
      })
    end,
  })
end

local function status_messages(limit)
  local count = limit or 200
  local output = vim.api.nvim_exec2("messages", { output = true }).output
  local lines = vim.split(output, "\n", { plain = true, trimempty = true })

  if count < #lines then
    lines = vim.list_slice(lines, #lines - count + 1, #lines)
  end

  local deduped = {}
  for index, line in ipairs(lines) do
    if index == 1 or line ~= lines[index - 1] then
      table.insert(deduped, line)
    end
  end

  return vim.fn.reverse(deduped)
end

local function infer_target_path(path)
  local target_path = ""

  if path:match("^app/") then
    if path:match("^app/controllers/") then
      target_path = vim.fn.substitute(path, "^app/controllers/", "spec/", "")
      target_path = vim.fn.substitute(target_path, [[\v(.+)_controller\.rb]], [[\1_spec.rb]], "")
    else
      target_path = vim.fn.substitute(path, "^app/", "spec/", "")
      target_path = vim.fn.substitute(target_path, [[\v(.+)\.rb]], [[\1_spec.rb]], "")
    end
  elseif path:match("^lib/") then
    target_path = vim.fn.substitute(path, "^lib/", "spec/lib/", "")
    target_path = vim.fn.substitute(target_path, [[\v(.+)\.rb]], [[\1_spec.rb]], "")
  elseif path:match("^spec/") then
    if path:match("^spec/requests/") then
      target_path = vim.fn.substitute(path, "^spec/requests/", "app/", "")
      target_path = vim.fn.substitute(target_path, [[\v(.+)\/.+_spec\.rb]], [[\1.rb]], "")
    elseif path:match("^spec/lib/") then
      target_path = vim.fn.substitute(path, "^spec/lib/", "lib/", "")
      target_path = vim.fn.substitute(target_path, [[\v(.+)_spec\.rb]], [[\1.rb]], "")
    else
      target_path = vim.fn.substitute(path, "^spec/", "app/", "")
      target_path = vim.fn.substitute(target_path, [[\v(.+)_spec\.rb]], [[\1.rb]], "")
    end
  end

  return target_path
end

function M.files(path)
  file_pickers.rg_files({
    prompt_title = "Files",
    search_dirs = normalize_search_dirs(path),
  })
end

function M.buffers()
  builtin.buffers(core.default_picker_opts({
    sort_mru = true,
    sort_lastused = true,
    ignore_current_buffer = false,
    attach_mappings = with_preview_toggle({}, function(prompt_bufnr, map, mode)
      map(mode, "<CR>", open_buffer_picker(jump_to_buffer))
      map(mode, "<C-e>", open_buffer_picker(edit_buffer))
      map(mode, "<C-s>", open_buffer_picker(split_buffer))
      map(mode, "<C-v>", open_buffer_picker(vsplit_buffer))
    end),
  }))
end

function M.windows()
  window_pickers.pick()
end

function M.open_files(path, sort)
  file_pickers.rg_files(legacy_file_opts(path, sort, {
    prompt_title = "Files",
  }))
end

function M.open_all_files()
  file_pickers.rg_files({
    prompt_title = "AllFiles",
    include_ignored = true,
    sort = "modified",
  })
end

function M.open_target_file()
  local target_path = infer_target_path(vim.fn.expand("%"))
  if target_path == "" then
    print("no target file")
    return
  end

  file_pickers.rg_files({
    prompt_title = "Files",
    sort = "modified",
    default_text = target_path,
  })
end

function M.search_word(word, path, sort)
  if word == "" then
    M.open_files(path, sort)
    return
  end

  grep_pickers.grep_string(legacy_file_opts(path, sort, {
    prompt_title = "Search",
    search = word,
    fixed_strings = true,
  }))
end

function M.selected_visual_mode_text()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local line_start = start_pos[2]
  local column_start = start_pos[3]
  local line_end = end_pos[2]
  local column_end = end_pos[3]
  local lines = vim.fn.getline(line_start, line_end)

  if #lines == 0 then
    return ""
  end

  local end_index = column_end - (vim.o.selection == "inclusive" and 0 or 1)
  lines[#lines] = string.sub(lines[#lines], 1, end_index)
  lines[1] = string.sub(lines[1], column_start)

  return table.concat(lines, "\n")
end

function M.search_word_by_selected_text()
  local selected = M.selected_visual_mode_text()
  vim.fn.setreg("+", selected)
  print("Copyed! " .. selected)
  M.search_word(selected)
end

function M.switch_project()
  local picker_opts = core.default_picker_opts({
    prompt_title = "Project",
    attach_mappings = with_preview_toggle({}, function(prompt_bufnr, map, mode)
      local function open_project()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if not selection or not selection.value then
          return
        end

        wipe_all_buffers()
        vim.cmd("silent! cd " .. vim.fn.fnameescape(selection.value))
        set_title()
      end

      map(mode, "<CR>", open_project)
      map(mode, "<C-e>", open_project)
    end),
  })

  pickers
    .new(picker_opts, {
      finder = finders.new_oneshot_job({ "ghq", "list", "--full-path" }, {}),
      previewer = preview_project_readme(),
      sorter = conf.generic_sorter(picker_opts),
    })
    :find()
end

function M.copy_status_message()
  local picker_opts = core.default_picker_opts({
    prompt_title = "Messages",
    previewer = false,
    attach_mappings = with_preview_toggle({}, function(prompt_bufnr, map, mode)
      local function copy_message()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if not selection or not selection.value then
          return
        end

        vim.fn.setreg("+", selection.value)
      end

      map(mode, "<CR>", copy_message)
      map(mode, "<C-e>", copy_message)
    end),
  })

  pickers
    .new(picker_opts, {
      finder = finders.new_table({
        results = status_messages(200),
        entry_maker = function(message)
          return {
            value = message,
            display = message,
            ordinal = message,
          }
        end,
      }),
      previewer = false,
      sorter = conf.generic_sorter(picker_opts),
    })
    :find()
end

return M
