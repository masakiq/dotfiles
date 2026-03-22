local helpers = dofile("vim/tests/helpers.lua")

local child = helpers.new_child_neovim()
local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set({
  hooks = {
    pre_once = child.setup,
    pre_case = child.reset,
    post_once = child.stop,
  },
})

T["diagnostics.lua configures diagnostic defaults and autocmds"] = function()
  local result = child.lua_get([[
    (function()
      dofile("vim/plugin/lsp/diagnostics.lua")

      local config = vim.diagnostic.config()

      return {
        updatetime = vim.o.updatetime,
        virtual_text = config.virtual_text,
        signs = config.signs,
        update_in_insert = config.update_in_insert,
        underline = config.underline,
        severity_sort = config.severity_sort,
        autocmd_count = #vim.api.nvim_get_autocmds({
          event = "CursorHold",
          group = "dotfiles_lsp_diagnostics",
        }),
      }
    end)()
  ]])

  eq(result.updatetime, 500)
  eq(result.virtual_text, false)
  eq(result.signs, true)
  eq(result.update_in_insert, false)
  eq(result.underline, false)
  eq(result.severity_sort, true)
  eq(result.autocmd_count, 1)
end

T["diagnostics.lua skips special buffers and lines without diagnostics"] = function()
  local calls = child.lua_get([[
    (function()
      local open_float_calls = 0

      dofile("vim/plugin/lsp/diagnostics.lua")

      vim.diagnostic.open_float = function()
        open_float_calls = open_float_calls + 1
      end

      vim.bo.buftype = "nofile"
      vim.api.nvim_exec_autocmds("CursorHold", { buffer = 0 })

      vim.bo.buftype = ""
      vim.api.nvim_exec_autocmds("CursorHold", { buffer = 0 })

      return open_float_calls
    end)()
  ]])

  eq(calls, 0)
end

T["diagnostics.lua dedupes duplicate diagnostics before opening the float"] = function()
  local result = child.lua_get([[
    (function()
      local ns = vim.api.nvim_create_namespace("phase3_diagnostics")
      local float_calls = {}

      dofile("vim/plugin/lsp/diagnostics.lua")

      vim.diagnostic.open_float = function(buf, opts)
        local rendered = {}

        for _, diagnostic in ipairs(vim.diagnostic.get(buf, { lnum = 0 })) do
          local line = opts.format(diagnostic)
          if line ~= nil then
            table.insert(rendered, line)
          end
        end

        table.insert(float_calls, {
          buf = buf,
          focus = opts.focus,
          scope = opts.scope,
          source = opts.source,
          rendered = rendered,
        })
      end

      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "phase3" })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
      vim.diagnostic.set(ns, 0, {
        {
          lnum = 0,
          col = 0,
          end_lnum = 0,
          end_col = 4,
          severity = vim.diagnostic.severity.WARN,
          code = "Same",
          message = "duplicate",
        },
        {
          lnum = 0,
          col = 0,
          end_lnum = 0,
          end_col = 4,
          severity = vim.diagnostic.severity.WARN,
          code = "Same",
          message = "duplicate",
        },
        {
          lnum = 0,
          col = 5,
          end_lnum = 0,
          end_col = 7,
          severity = vim.diagnostic.severity.ERROR,
          code = "Other",
          message = "other",
        },
      })

      vim.api.nvim_exec_autocmds("CursorHold", { buffer = 0 })

      return vim.tbl_extend("force", float_calls[1], {
        current_buf = vim.api.nvim_get_current_buf(),
      })
    end)()
  ]])

  eq(result.buf, result.current_buf)
  eq(result.focus, false)
  eq(result.scope, "line")
  eq(result.source, "if_many")
  eq(result.rendered, { "duplicate", "other" })
end

return T
