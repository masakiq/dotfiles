local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["oil_nvim.lua configures callbacks, autocmds, winbar, and toggle mapping"] = function()
  helpers.track_editor_state({
    modules = { "oil" },
    lua_globals = { "get_oil_winbar" },
  })

  local setup_config
  local close_calls = 0
  local select_calls = 0
  local preview_calls = 0
  local toggle_calls = 0
  local set_columns_calls = {}
  local commands = {}

  local oil_module = {
    setup = function(config)
      setup_config = config
    end,
    get_cursor_entry = function()
      return { name = "notes.md" }
    end,
    get_current_dir = function()
      return "/repo/docs/"
    end,
    close = function()
      close_calls = close_calls + 1
    end,
    select = function()
      select_calls = select_calls + 1
    end,
    set_columns = function(columns)
      set_columns_calls = columns
    end,
    open_preview = function()
      preview_calls = preview_calls + 1
    end,
    toggle_float = function()
      toggle_calls = toggle_calls + 1
    end,
  }

  helpers.stub(vim.loop, "fs_stat", function(path)
    if path:match("%.md$") then
      return { type = "file" }
    end

    return { type = "directory" }
  end)
  helpers.stub(vim.fn, "fnamemodify", function(path, modifier)
    if modifier == ":." then
      return "docs/notes.md"
    end

    if modifier:match("^:%.") then
      return "docs"
    end

    return path
  end)
  helpers.stub(vim.fn, "getcwd", function()
    return "/repo"
  end)
  helpers.stub(vim, "schedule", function(callback)
    callback()
  end)
  helpers.stub(vim, "cmd", function(command)
    table.insert(commands, command)
  end)

  helpers.with_module_stubs({
    oil = oil_module,
  }, function()
    dofile("vim/plugin/oil_nvim.lua")
  end)

  setup_config.keymaps["<C-s>"].callback()
  setup_config.keymaps["<Enter>"].callback()

  local toggle_mapping = vim.fn.maparg("<space>oe", "n", false, true)
  toggle_mapping.callback()

  local user_autocmd = vim.api.nvim_get_autocmds({
    event = "User",
    pattern = "OilEnter",
  })[1]
  user_autocmd.callback({
    data = { buf = vim.api.nvim_get_current_buf() },
  })

  eq(setup_config.delete_to_trash, true)
  eq(setup_config.float.padding, 3)
  eq(setup_config.view_options.show_hidden, true)
  eq(close_calls, 2)
  eq(select_calls, 0)
  eq(preview_calls, 1)
  eq(toggle_calls, 1)
  eq(set_columns_calls, { "size", "mtime", "icon" })
  eq(commands, {
    "split docs/notes.md",
    "tab drop docs/notes.md",
    "set nonumber",
  })
  eq(_G.get_oil_winbar(), "docs")
  eq(toggle_mapping.desc, "Oil current buffer's directory")
end

return T
