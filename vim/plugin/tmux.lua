local function mode_vim()
  vim.fn.system("mode_vim")
end

local function mode_test()
  vim.fn.system("mode_test")
end

local function mode_ai()
  vim.fn.system("mode_ai")
end

vim.keymap.set("n", "<leader>v", mode_vim, { desc = "Switch to vim mode" })
vim.keymap.set("n", "<leader>t", mode_test, { desc = "Switch to test mode" })
vim.keymap.set("n", "<leader>a", mode_ai, { desc = "Switch to ai mode" })
