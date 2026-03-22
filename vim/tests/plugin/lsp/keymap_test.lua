local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["keymap.lua configures completeopt and dispatches LSP telescope mappings"] = function()
  helpers.track_editor_state({
    options = { "completeopt" },
    modules = { "telescope.builtin" },
  })

  local calls = {}

  helpers.stub(vim.lsp.buf, "format", function(opts)
    table.insert(calls, { name = "format", opts = opts })
  end)

  helpers.stub(vim.lsp.buf, "hover", function()
    table.insert(calls, { name = "hover" })
  end)

  helpers.with_module_stubs({
    ["telescope.builtin"] = {
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
    },
  }, function()
    dofile("vim/plugin/lsp/keymap.lua")
  end)

  vim.fn.maparg("<space>f", "n", false, true).callback()
  vim.fn.maparg("gd", "n", false, true).callback()
  vim.fn.maparg("gr", "n", false, true).callback()
  vim.fn.maparg("gi", "n", false, true).callback()
  vim.fn.maparg("<space>ds", "n", false, true).callback()
  vim.fn.maparg("<space>ws", "n", false, true).callback()
  vim.fn.maparg("K", "n", false, true).callback()

  eq(vim.opt.completeopt:get(), { "menu", "menuone", "noselect" })
  eq(vim.fn.maparg("<space>f", "n", false, true).desc, "Format document")
  eq(vim.fn.maparg("gd", "n", false, true).desc, "Telescope: Go to definition")
  eq(vim.fn.maparg("K", "n", false, true).desc, "Show documentation")
  eq(calls[1], { name = "format", opts = { async = true } })
  eq(calls[2], { name = "definitions", opts = { jump_type = "never" } })
  eq(calls[3], { name = "references", opts = { jump_type = "never" } })
  eq(calls[4], { name = "implementations" })
  eq(calls[5], { name = "document_symbols" })
  eq(calls[6], { name = "workspace_symbols" })
  eq(calls[7], { name = "hover" })
end

return T
