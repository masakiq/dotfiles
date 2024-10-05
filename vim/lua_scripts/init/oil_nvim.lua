require("oil").setup({
  delete_to_trash = true,
  win_options = {
    winbar = "%!v:lua.get_oil_winbar()",
  },
  float = {
    padding = 3,
  },
})

vim.api.nvim_create_augroup("OilRelPathFix", {})
vim.api.nvim_create_autocmd("BufLeave", {
  group = "OilRelPathFix",
  pattern = "oil:///*",
  callback = vim.schedule_wrap(function()
    vim.cmd("cd .")
  end),
});

vim.api.nvim_create_autocmd("User", {
  pattern = "OilEnter",
  callback = vim.schedule_wrap(function(args)
    local oil = require("oil")
    oil.set_columns({ "size", "mtime" })
    if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
      oil.open_preview()
      vim.cmd("set nonumber")
    end
  end),
})

-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
  local dir = require("oil").get_current_dir()
  if dir then
    local current_dir = vim.fn.getcwd()
    return vim.fn.fnamemodify(dir, ":." .. current_dir)
  else
    return vim.api.nvim_buf_get_name(0)
  end
end

vim.keymap.set("n", "<space>oe", function()
  require("oil").toggle_float()
end, { desc = "Oil current buffer's directory" })
