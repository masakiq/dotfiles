-- タブの画面上での幅
vim.opt.tabstop = 2

-- 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
vim.opt.softtabstop = 2

-- 自動インデントでずれる幅
vim.opt.shiftwidth = 2

-- タブをスペースに展開する
vim.opt.expandtab = true

-- 自動的にインデントする
vim.opt.autoindent = true

-- バックスペースでインデントや改行を削除できるようにする
vim.opt.backspace = "indent,eol,start"

-- 検索時にファイルの最後まで行ったら最初に戻る
vim.opt.wrapscan = true

-- 括弧入力時に対応する括弧を表示
vim.opt.showmatch = true

-- コマンドライン補完するときに強化されたものを使う
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"

-- テキスト挿入中の自動折り返しを日本語に対応させる
vim.opt.formatoptions:append("mM")

-- タイポチェック
vim.opt.spell = true
vim.opt.spelllang:append("cjk")

-- バッファ切り替え時のワーニングを無視
vim.opt.hidden = true

-- 保存時に行末空白削除（マークダウン以外）
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "markdown" then
      -- 現在の位置を保存
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      -- 行末の空白を削除
      vim.cmd([[%s/\s\+$//ge]])
      -- カーソル位置を復元
      vim.api.nvim_win_set_cursor(0, cursor_pos)
    end
  end,
})

-- Undo の永続化
local undo_path = vim.fn.expand("~/.local/share/nvim/undo")
vim.fn.mkdir(undo_path, "p")
vim.opt.undodir = undo_path
vim.opt.undofile = true
