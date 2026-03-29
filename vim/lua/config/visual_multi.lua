local M = {}
local mono_highlight_group = "VisualMultiMono"

function M.setup()
  vim.g.VM_maps = {
    Align = "<M-a>",
    Surround = "S",
    ["Case Conversion Menu"] = "C",
    ["Add Cursor Down"] = "<M-Down>",
    ["Add Cursor Up"] = "<M-Up>",
  }
  vim.g.VM_Mono_hl = mono_highlight_group
end

function M.apply_highlights()
  vim.api.nvim_set_hl(0, mono_highlight_group, {
    fg = "#1f2335",
    bg = "#e0af68",
  })
end

return M
