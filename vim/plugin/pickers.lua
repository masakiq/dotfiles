local picker_commands = require("commands.pickers")

vim.api.nvim_create_user_command("Files", function(opts)
  picker_commands.files(opts.args)
end, {
  bang = true,
  complete = "dir",
  nargs = "?",
})

vim.api.nvim_create_user_command("Buffers", function()
  picker_commands.buffers()
end, {
  bang = true,
  complete = "dir",
  nargs = "?",
})

vim.api.nvim_create_user_command("Windows", function()
  picker_commands.windows()
end, {
  bang = true,
  complete = "dir",
  nargs = "?",
})

vim.api.nvim_create_user_command("OpenAllFiles", function()
  picker_commands.open_all_files()
end, {})

vim.api.nvim_create_user_command("OpenTargetFile", function()
  picker_commands.open_target_file()
end, {})

vim.api.nvim_create_user_command("CopyStatusMessage", function()
  picker_commands.copy_status_message()
end, {})

vim.api.nvim_create_user_command("SwitchProject", function()
  picker_commands.switch_project()
end, {})

vim.keymap.set("n", "<space>of", function()
  picker_commands.open_files()
end, { silent = true })

vim.keymap.set("n", "<space>op", "<cmd>SwitchProject<CR>", { silent = true })
vim.keymap.set("n", "<space>ot", function()
  picker_commands.open_target_file()
end, { desc = "Open Target File", silent = true })
vim.keymap.set("x", "<space>/", function()
  picker_commands.search_word_by_selected_text()
end, { silent = true })
