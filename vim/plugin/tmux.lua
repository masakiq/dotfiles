local function mode_vim()
  vim.fn.system("mode_vim")
end

local function mode_test()
  vim.fn.system("mode_test")
end

local function mode_ai()
  vim.fn.system("mode_ai")
end

local term = vim.env.TERM or ""

if term:match("^screen") then
  vim.cmd([[execute "set <xUp>=\e[1;*A"]])
  vim.cmd([[execute "set <xDown>=\e[1;*B"]])
  vim.cmd([[execute "set <xRight>=\e[1;*C"]])
  vim.cmd([[execute "set <xLeft>=\e[1;*D"]])
end

vim.keymap.set("n", "<leader>v", mode_vim, { desc = "Switch to vim mode" })
vim.keymap.set("n", "<leader>t", mode_test, { desc = "Switch to test mode" })
vim.keymap.set("n", "<leader>a", mode_ai, { desc = "Switch to ai mode" })
