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

local function find_item(items, label)
  for _, item in ipairs(items) do
    if item.label == label then
      return item
    end
  end

  error("Item not found: " .. label)
end

local function load_module()
  child.lua([[
    package.loaded["pickers.windows"] = nil
    package.loaded["telescope.actions"] = {
      close = function() end,
      preview_scrolling_down = function() end,
      preview_scrolling_up = function() end,
    }
    package.loaded["telescope.actions.layout"] = {
      toggle_preview = function() end,
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
        buffer_previewer_maker = function() end,
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
    package.loaded["telescope.pickers.entry_display"] = {
      create = function()
        return function(items)
          return items
        end
      end,
    }
    package.loaded["telescope.finders"] = {
      new_table = function(opts)
        return opts
      end,
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
    package.loaded["telescope.previewers"] = {
      new_buffer_previewer = function(opts)
        return opts
      end,
    }

    M = require("pickers.windows")
  ]])
end

T["collect() lists windows with labels and current flag"] = function()
  load_module()

  local items = child.lua_get([[
    (function()
      vim.cmd("edit first.txt")
      vim.cmd("vsplit")
      vim.cmd("enew")
      vim.api.nvim_buf_set_name(0, "second.txt")
      vim.bo.modified = true
      vim.cmd("tabnew")
      vim.cmd("edit third.txt")

      return M.collect()
    end)()
  ]])

  eq(#items, 3)
  eq(find_item(items, "first.txt").modified, false)
  eq(find_item(items, "second.txt").modified, true)
  eq(find_item(items, "third.txt").is_current, true)
end

T["jump() focuses the selected window"] = function()
  load_module()

  local result = child.lua_get([[
    (function()
      vim.cmd("edit first.txt")
      vim.cmd("tabnew")
      vim.cmd("edit third.txt")

      local items = M.collect()
      M.jump(items[1])

      return {
        current_buf = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t"),
        current_tab = vim.api.nvim_get_current_tabpage() == items[1].tabpage,
        current_win = vim.api.nvim_get_current_win() == items[1].win,
      }
    end)()
  ]])

  eq(result.current_buf, "first.txt")
  eq(result.current_tab, true)
  eq(result.current_win, true)
end

return T
