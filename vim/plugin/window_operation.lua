local function swap_window()
  vim.cmd('silent! exec "normal! \\<C-w>x"')
end

vim.api.nvim_create_user_command("SwapWindow", swap_window, {})
