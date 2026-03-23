local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["legacy_plugin_settings.lua registers globals and commentary/move mappings"] = function()
  helpers.track_editor_state({
    globals = {
      "dart_html_in_string",
      "dart_style_guide",
      "VM_maps",
      "tabline_charmax",
      "move_map_keys",
      "move_past_end_of_line",
      "html_indent_script1",
      "html_indent_style1",
      "vim_markdown_folding_disabled",
      "vim_markdown_folding_level",
    },
  })

  dofile("vim/plugin/legacy_plugin_settings.lua")

  eq(vim.g.dart_html_in_string, true)
  eq(vim.g.dart_style_guide, 2)
  eq(vim.g.VM_maps["Add Cursor Down"], "<M-Down>")
  eq(vim.g.tabline_charmax, 40)
  eq(vim.g.move_map_keys, 0)
  eq(vim.g.html_indent_script1, "inc")
  eq(vim.g.vim_markdown_folding_level, 4)
  eq(vim.fn.maparg("<M-j>", "n"), "<Plug>MoveLineDown")
  eq(vim.fn.maparg("<leader>c", "n"), "<Cmd>Commentary<CR>")
  eq(vim.fn.maparg("<leader>c", "x"), "<Plug>Commentary")
end

return T
