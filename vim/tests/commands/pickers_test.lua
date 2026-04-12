local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

local function load_module()
  local state = {}

  local module = helpers.require_with_stubs("commands.pickers", {
    ["telescope.actions"] = {
      close = function() end,
      preview_scrolling_down = function() end,
      preview_scrolling_up = function() end,
    },
    ["telescope.actions.layout"] = {
      toggle_preview = function() end,
    },
    ["telescope.actions.state"] = {
      get_selected_entry = function()
        return state.selected_entry
      end,
    },
    ["telescope.builtin"] = {
      buffers = function(opts)
        state.buffers_opts = opts
      end,
    },
    ["telescope.config"] = {
      values = {
        generic_sorter = function()
          return "generic-sorter"
        end,
        buffer_previewer_maker = function() end,
      },
    },
    ["telescope.finders"] = {
      new_oneshot_job = function(command, opts)
        state.oneshot_job = {
          command = command,
          opts = opts,
        }
        return "oneshot-job"
      end,
      new_table = function(opts)
        state.table_finder = opts
        return "table-finder"
      end,
    },
    ["pickers.core"] = {
      default_picker_opts = function(opts)
        return opts or {}
      end,
      chain_attach_mappings = function(...)
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
      end,
    },
    ["pickers.files"] = {
      rg_files = function(opts)
        state.file_calls = state.file_calls or {}
        table.insert(state.file_calls, opts)
      end,
    },
    ["pickers.grep"] = {
      grep_string = function(opts)
        state.grep_calls = state.grep_calls or {}
        table.insert(state.grep_calls, opts)
      end,
    },
    ["telescope.pickers"] = {
      new = function(opts, spec)
        state.picker = {
          opts = opts,
          spec = spec,
        }

        return {
          find = function()
            state.find_called = true
          end,
        }
      end,
    },
    ["telescope.previewers"] = {
      new_buffer_previewer = function(opts)
        state.previewer = opts
        return opts
      end,
    },
    ["pickers.windows"] = {
      pick = function(opts)
        state.window_pick = opts
      end,
    },
  })

  return module, state
end

T["open_files() applies legacy default sort"] = function()
  local pickers, state = load_module()

  pickers.open_files()

  eq(state.file_calls[1].prompt_title, "Files")
  eq(state.file_calls[1].sort, "modified")
end

T["open_all_files() includes ignored files"] = function()
  local pickers, state = load_module()

  pickers.open_all_files()

  eq(state.file_calls[1], {
    prompt_title = "AllFiles",
    include_ignored = true,
    sort = "modified",
  })
end

T["open_target_file() derives matching spec path"] = function()
  local pickers, state = load_module()
  local buf = helpers.make_scratch_buffer({ "class User; end" }, "app/models/user.rb")

  pickers.open_target_file()

  eq(vim.api.nvim_get_current_buf(), buf)
  eq(state.file_calls[1].default_text, "spec/models/user_spec.rb")
  eq(state.file_calls[1].sort, "modified")
end

T["search_word() dispatches to rg files when query is empty"] = function()
  local pickers, state = load_module()

  pickers.search_word("", "vim/lua", "path")

  eq(state.file_calls[1].prompt_title, "Files")
  eq(state.file_calls[1].sort, "path")
  eq(state.file_calls[1].search_dirs, { vim.fn.expand("vim/lua") })
end

T["search_word() dispatches to grep picker without redundant fixed-string opts"] = function()
  local pickers, state = load_module()

  pickers.search_word("TODO", "vim/lua", "path")

  eq(state.grep_calls[1].prompt_title, "Search")
  eq(state.grep_calls[1].search, "TODO")
  eq(state.grep_calls[1].sort, "path")
end

T["selected_visual_mode_text() reads current visual marks"] = function()
  local pickers = load_module()
  local buf = helpers.make_scratch_buffer({ "AlphaBeta" })

  vim.api.nvim_set_current_buf(buf)
  vim.o.selection = "inclusive"
  vim.fn.setpos("'<", { 0, 1, 2, 0 })
  vim.fn.setpos("'>", { 0, 1, 6, 0 })

  eq(pickers.selected_visual_mode_text(), "lphaB")
end

T["search_word_by_selected_text() copies selection and searches it"] = function()
  local pickers, state = load_module()
  local buf = helpers.make_scratch_buffer({ "AlphaBeta" })
  local original_print = print
  local original_setreg = vim.fn.setreg
  local copied_text

  vim.api.nvim_set_current_buf(buf)
  vim.o.selection = "inclusive"
  vim.fn.setpos("'<", { 0, 1, 1, 0 })
  vim.fn.setpos("'>", { 0, 1, 5, 0 })
  _G.print = function() end
  vim.fn.setreg = function(_, value)
    copied_text = value
  end

  MiniTest.finally(function()
    _G.print = original_print
    vim.fn.setreg = original_setreg
  end)

  pickers.search_word_by_selected_text()

  eq(copied_text, "Alpha")
  eq(state.grep_calls[1].search, "Alpha")
end

return T
