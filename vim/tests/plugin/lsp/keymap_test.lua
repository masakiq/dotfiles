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

T["keymap.lua configures completeopt and dispatches LSP telescope mappings"] = function()
  local result = child.lua_get([[
    (function()
      local calls = {}

      package.loaded["telescope.builtin"] = {
        lsp_definitions = function(opts)
          table.insert(calls, { name = "definitions", opts = opts })
        end,
        lsp_references = function(opts)
          table.insert(calls, { name = "references", opts = opts })
        end,
        lsp_implementations = function()
          table.insert(calls, { name = "implementations" })
        end,
        lsp_document_symbols = function()
          table.insert(calls, { name = "document_symbols" })
        end,
        lsp_workspace_symbols = function()
          table.insert(calls, { name = "workspace_symbols" })
        end,
      }

      vim.lsp.buf.format = function(opts)
        table.insert(calls, { name = "format", opts = opts })
      end

      vim.lsp.buf.hover = function()
        table.insert(calls, { name = "hover" })
      end

      dofile("vim/plugin/lsp/keymap.lua")

      vim.fn.maparg("<space>f", "n", false, true).callback()
      vim.fn.maparg("gd", "n", false, true).callback()
      vim.fn.maparg("gr", "n", false, true).callback()
      vim.fn.maparg("gi", "n", false, true).callback()
      vim.fn.maparg("<space>ds", "n", false, true).callback()
      vim.fn.maparg("<space>ws", "n", false, true).callback()
      vim.fn.maparg("K", "n", false, true).callback()

      return {
        completeopt = vim.opt.completeopt:get(),
        format_desc = vim.fn.maparg("<space>f", "n", false, true).desc,
        definition_desc = vim.fn.maparg("gd", "n", false, true).desc,
        hover_desc = vim.fn.maparg("K", "n", false, true).desc,
        calls = calls,
      }
    end)()
  ]])

  eq(result.completeopt, { "menu", "menuone", "noselect" })
  eq(result.format_desc, "Format document")
  eq(result.definition_desc, "Telescope: Go to definition")
  eq(result.hover_desc, "Show documentation")
  eq(result.calls[1], { name = "format", opts = { async = true } })
  eq(result.calls[2], { name = "definitions", opts = { jump_type = "never" } })
  eq(result.calls[3], { name = "references", opts = { jump_type = "never" } })
  eq(result.calls[4], { name = "implementations" })
  eq(result.calls[5], { name = "document_symbols" })
  eq(result.calls[6], { name = "workspace_symbols" })
  eq(result.calls[7], { name = "hover" })
end

return T
