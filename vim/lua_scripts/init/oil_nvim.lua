require("oil").setup({
  delete_to_trash = true,
})

vim.api.nvim_create_augroup("OilRelPathFix", {})
vim.api.nvim_create_autocmd("BufLeave", {
  group = "OilRelPathFix",
  pattern = "oil:///*",
  callback = function()
    vim.cmd("cd .")
  end,
})

vim.keymap.set("n", "<space>oe", function()
  require("oil").open()
end, { desc = "Oil current buffer's directory" })
