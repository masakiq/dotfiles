local M = {}

function M.search_word(path)
  local Input = require("nui.input")
  path = path or ""

  local input = Input({
    position = {
      row = '30%',
      col = '50%',
    },
    size = {
      width = 60,
    },
    border = {
      style = "double",
      text = {
        top = " Search in " .. (path:match("/([^/]+)$") or 'Current Directory') .. " (or Find Files) ",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    prompt = "> ",
    default_value = "",
    on_close = function()
      print("Input Closed!")
    end,
    on_submit = function(value)
      vim.cmd('call SearchWord("' .. value .. '", "' .. path .. '")')
    end,
  })

  -- mount/open the component
  input:mount()

  -- unmount component when escape is pressed
  input:map("n", "<Esc>", function()
    input:unmount()
  end, { noremap = true })

  input:map("i", "<Esc>", function()
    input:unmount()
  end, { noremap = true })

  input:map("n", "<C-c>", function()
    input:unmount()
  end, { noremap = true })

  input:map("i", "<C-c>", function()
    input:unmount()
  end, { noremap = true })
end

return M
