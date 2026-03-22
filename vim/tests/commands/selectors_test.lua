local helpers = dofile("vim/tests/helpers.lua")

local child = helpers.new_child_neovim()
local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set({
  hooks = {
    pre_case = child.setup,
    post_once = child.stop,
  },
})

local function load_module(extra_setup)
  child.lua([[
    package.loaded["commands.selectors"] = nil
    package.loaded["telescope.actions"] = {
      close = function(prompt_bufnr)
        _G.closed_prompt = prompt_bufnr
      end,
      preview_scrolling_down = function() end,
      preview_scrolling_up = function() end,
    }
    package.loaded["telescope.actions.state"] = {
      get_selected_entry = function()
        return _G.selected_entry
      end,
    }
    package.loaded["telescope.config"] = {
      values = {
        generic_sorter = function()
          return "generic-sorter"
        end,
      },
    }
    package.loaded["pickers.core"] = {
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
    }
    package.loaded["telescope.finders"] = {
      new_table = function(opts)
        return opts
      end,
    }
    package.loaded["selectors.normal"] = {
      entries = _G.normal_entries or {},
    }
    package.loaded["telescope.pickers"] = {
      new = function(opts, spec)
        _G.last_picker = { opts = opts, spec = spec }

        return {
          find = function()
            _G.picker_found = true
          end,
        }
      end,
    }
    vim.schedule = function(callback)
      callback()
    end
  ]])

  if extra_setup then
    child.lua(extra_setup)
  end

  child.lua([[
    package.loaded["selectors.visual"] = {
      entries = _G.visual_entries or {},
    }

    M = require("commands.selectors")
  ]])
end

T["capture_active_visual_context() returns normalized selection text"] = function()
  load_module()

  child.set_lines({ "AlphaBeta", "Gamma" })
  child.set_cursor(1, 0)
  child.type_keys("v", "4l")

  local context = child.lua_get("M.capture_active_visual_context()")

  eq(context.start_line, 1)
  eq(context.start_col, 1)
  eq(context.end_line, 1)
  eq(context.end_col, 5)
  eq(context.text, "Alpha")
  eq(context.visual_mode, "v")
end

T["select_visual_function() warns if selection is missing"] = function()
  load_module([[
    _G.notifications = {}
    vim.notify = function(message, level)
      table.insert(_G.notifications, { message = message, level = level })
    end
    vim.ui.select = function()
      _G.select_called = true
    end
  ]])

  child.lua([[
    M.select_visual_function({
      start_line = 0,
      end_line = 0,
    })
  ]])

  eq(child.lua_get("_G.select_called == nil"), true)
  eq(child.lua_get("_G.notifications[1].message"), "No visual selection found.")
  eq(child.lua_get("_G.notifications[1].level"), vim.log.levels.WARN)
end

T["select_visual_function() filters unavailable commands and runs callbacks"] = function()
  load_module([[
    _G.callback_context = nil
    _G.select_labels = {}
    _G.visual_entries = {
      {
        label = "Callback",
        callback = function(context)
          _G.callback_context = context
        end,
      },
      {
        label = "MissingCommand",
        command = "DoesNotExist",
      },
    }
    vim.ui.select = function(items, _, on_choice)
      _G.select_labels = vim.tbl_map(function(item)
        return item.label
      end, items)
      on_choice(items[1])
    end
  ]])

  child.lua([[
    M.select_visual_function({
      bufnr = vim.api.nvim_get_current_buf(),
      winid = vim.api.nvim_get_current_win(),
      start_line = 1,
      start_col = 1,
      end_line = 1,
      end_col = 4,
      text = "test",
    })
  ]])

  eq(child.lua_get("_G.select_labels"), { "Callback" })
  eq(child.lua_get("_G.callback_context.text"), "test")
end

T["select_visual_function() restores marks before running command entries"] = function()
  load_module([[
    _G.command_marks = nil
    _G.visual_entries = {
      {
        label = "RecordedVisualCommand",
        command = "RecordedVisualCommand",
      },
    }
    vim.api.nvim_create_user_command("RecordedVisualCommand", function()
      _G.command_marks = {
        first = vim.fn.getpos("'<"),
        last = vim.fn.getpos("'>"),
      }
    end, {})
    vim.ui.select = function(items, _, on_choice)
      on_choice(items[1])
    end
  ]])

  child.lua([[
    vim.fn.setpos("'<", { 0, 1, 1, 0 })
    vim.fn.setpos("'>", { 0, 1, 2, 0 })

    M.select_visual_function({
      bufnr = vim.api.nvim_get_current_buf(),
      winid = vim.api.nvim_get_current_win(),
      start_line = 2,
      start_col = 3,
      end_line = 2,
      end_col = 6,
      text = "bbbb",
    })
  ]])

  eq(child.lua_get("_G.command_marks.first[2]"), 2)
  eq(child.lua_get("_G.command_marks.first[3]"), 3)
  eq(child.lua_get("_G.command_marks.last[2]"), 2)
  eq(child.lua_get("_G.command_marks.last[3]"), 6)
end

return T
