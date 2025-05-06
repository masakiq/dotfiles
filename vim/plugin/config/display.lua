-- シンタックス
vim.cmd("syntax enable")

-- タイトルを表示する
vim.opt.title = true

-- 行番号を表示
vim.opt.number = true

-- ルーラーを表示
vim.opt.ruler = true

-- タブや改行を非表示
vim.opt.list = false

-- 長い行を折り返して表示
vim.opt.wrap = true

-- 常にステータス行を表示
vim.opt.laststatus = 2

-- コマンドラインの高さ
vim.opt.cmdheight = 1

-- コマンドをステータス行に表示
vim.opt.showcmd = true

-- モードを表示する
vim.opt.showmode = true

-- アンダーライン
vim.opt.cursorline = true

-- ファイルを自動読み込み
vim.opt.autoread = true

-- 最初は折りたたみを展開
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*",
  callback = function()
    vim.cmd("normal zR")
  end,
})

-- カラースキーマ設定
vim.cmd("colorscheme tokyonight")

-- シンタックスエラーを下線にする
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true })

-- 背景色
vim.api.nvim_set_hl(0, "Normal", { fg = "NONE", bg = "#000000" })
-- 空の行の `~` を非表示に
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#000000", bg = "#000000" })
-- ウィンドウ間のバーをカスタマイズ
vim.api.nvim_set_hl(0, "VertSplit", { fg = "#000000", bg = "#000000" })
-- ウィンドウ区切りを空白に
vim.opt.fillchars:append({ vert = " " })
vim.api.nvim_set_hl(0, "SignColumn", { fg = "NONE", bg = "#000000" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#777777", bg = "NONE" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#eeeeee", bg = "#222222" })
vim.api.nvim_set_hl(0, "CursorLine", { fg = "NONE", bg = "#222222" })
vim.api.nvim_set_hl(0, "CursorColumn", { fg = "NONE", bg = "#222222" })

-- タブ
vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#eeeeee", bg = "NONE" })
vim.api.nvim_set_hl(0, "TabLine", { fg = "#777777", bg = "NONE" })
vim.api.nvim_set_hl(0, "TabLineFill", { fg = "#777777", bg = "NONE" })

-- フローティングウィンドウ
vim.api.nvim_set_hl(0, "NormalFloat", { fg = "NONE", bg = "#000000" })

-- txtファイルのシンタックス
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.txt",
  command = "set syntax=conf",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.fish",
  command = "set syntax=sh",
})

-- *.logのシンタックスカスタマイズ
vim.api.nvim_set_hl(0, "keywordWhen", { fg = "green" })
vim.api.nvim_set_hl(0, "matchBehavesLikeTo", { fg = "magenta" })

-- vimrcsyntaxグループの作成
local vimrcsyntax = vim.api.nvim_create_augroup("vimrcsyntax", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = vimrcsyntax,
  pattern = "log",
  callback = function()
    vim.cmd("syntax keyword keywordWhen when containedin=ALL")
    vim.cmd("syntax match matchBehavesLikeTo /behaves like/ containedin=ALL")
  end,
})
