-- 新規タブを開く
vim.keymap.set("n", "<space>t", vim.cmd.tabnew, { desc = "新規タブを開く" })

-- GUIモードでの条件分岐
if vim.fn.has("gui_running") == 1 then
  -- GUIモードでは特別なマッピングは不要
else
  -- 前のタブに移動
  vim.keymap.set("n", "<space>;", function()
    vim.cmd("normal gT")
  end, { desc = "前のタブに移動" })
  -- 次のタブに移動
  vim.keymap.set("n", "<space>'", function()
    vim.cmd("normal gt")
  end, { desc = "次のタブに移動" })
  -- 現タブを右に移動
  vim.keymap.set("n", "<space><right>", function()
    vim.cmd("+tabmove")
  end, { desc = "現タブを右に移動" })
  -- 現タブを左に移動
  vim.keymap.set("n", "<space><left>", function()
    vim.cmd("-tabmove")
  end, { desc = "現タブを左に移動" })
end
