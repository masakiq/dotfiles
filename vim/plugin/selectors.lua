local selector_commands = require("commands.selectors")

vim.api.nvim_create_user_command("SelectFunction", function()
  selector_commands.select_function()
end, {})

vim.api.nvim_create_user_command("SelectVisualFunction", function()
  selector_commands.select_visual_function()
end, {})

vim.api.nvim_create_user_command("SelectVidualFunction", function()
  selector_commands.select_visual_function()
end, {})

vim.keymap.set("n", "<space><space>", "<cmd>SelectFunction<CR>", { silent = true })
vim.keymap.set("x", "<space><space>", function()
  selector_commands.select_visual_function(selector_commands.capture_active_visual_context())
end, { silent = true })
