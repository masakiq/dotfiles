-- NextQuickfix関数とコマンドの定義
local function next_quickfix()
  vim.cmd("silent! cnewer")
end

vim.api.nvim_create_user_command("NextQuickfix", next_quickfix, {})

-- PreviousQuickfix関数とコマンドの定義
local function previous_quickfix()
  vim.cmd("silent! colder")
end

vim.api.nvim_create_user_command("PreviousQuickfix", previous_quickfix, {})

-- ToggleQuickFix関数とコマンドの定義
local function toggle_quickfix()
  -- クイックフィックスウィンドウが開いているか確認
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_exists = true
      break
    end
  end

  -- 開いていれば閉じる、閉じていれば開く
  if qf_exists then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end

vim.api.nvim_create_user_command("ToggleQuickfix", toggle_quickfix, {})

-- キーマッピングの定義
vim.keymap.set("n", "<leader>'", next_quickfix, { desc = "新しいクイックフィックスリストへ移動" })
vim.keymap.set("n", "<leader>;", previous_quickfix, { desc = "古いクイックフィックスリストへ移動" })
vim.keymap.set(
  "n",
  "<space>a",
  toggle_quickfix,
  { desc = "クイックフィックスウィンドウの表示/非表示を切り替え" }
)
