local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

local function load_module()
  local state = {}

  state.current_picker = {
    get_multi_selection = function()
      return state.multi_selection or {}
    end,
  }

  local module = helpers.require_with_stubs("pickers.actions", {
    ["telescope.actions"] = {
      close = function(prompt_bufnr)
        state.closed_prompt = prompt_bufnr
      end,
    },
    ["telescope.actions.state"] = {
      get_current_picker = function()
        return state.current_picker
      end,
      get_selected_entry = function()
        return state.selected_entry
      end,
    },
  })

  return module, state
end

T["collect_selected_entries() falls back to current selection"] = function()
  local actions, state = load_module()

  state.selected_entry = {
    path = "current.txt",
  }

  eq(actions.collect_selected_entries(12), { state.selected_entry })

  state.multi_selection = {
    { path = "first.txt" },
    { path = "second.txt" },
  }

  eq(actions.collect_selected_entries(12), state.multi_selection)
end

T["to_qflist_item() resolves filename and location fields"] = function()
  local actions = load_module()

  eq(
    actions.to_qflist_item({
      value = {
        path = "app/models/user.rb",
        lnum = 7,
        col = 3,
        text = "User.find",
      },
    }),
    {
      filename = "app/models/user.rb",
      lnum = 7,
      col = 3,
      text = "User.find",
    }
  )
end

T["open_entry() edits resolved file path and moves cursor"] = function()
  local actions = load_module()
  local path = vim.fn.tempname() .. ".txt"
  local handle = assert(io.open(path, "w"))

  handle:write("one\ntwoooo\nthree\n")
  handle:close()

  MiniTest.finally(function()
    vim.cmd("enew!")
    os.remove(path)
  end)

  eq(
    actions.open_entry("edit", {
      filename = path,
      lnum = 2,
      col = 3,
    }),
    true
  )
  eq(vim.loop.fs_realpath(vim.api.nvim_buf_get_name(0)), vim.loop.fs_realpath(path))
  eq(vim.api.nvim_win_get_cursor(0), { 2, 3 })
end

T["send_to_qflist() populates quickfix and opens it by default"] = function()
  local actions = load_module()
  local executed_commands = {}
  local original_cmd = vim.cmd

  vim.cmd = function(command)
    table.insert(executed_commands, command)
  end

  MiniTest.finally(function()
    vim.cmd = original_cmd
  end)

  local count = actions.send_to_qflist({
    { filename = "first.rb", lnum = 1, col = 1, text = "first" },
    { filename = "second.rb", lnum = 2, col = 2, text = "second" },
  }, {
    title = "Results",
  })

  eq(count, 2)
  eq(vim.fn.getqflist({ title = 1, size = 1 }).title, "Results")
  eq(vim.fn.getqflist({ title = 1, size = 1 }).size, 2)
  eq(executed_commands, { "copen", "wincmd p" })
end

return T
