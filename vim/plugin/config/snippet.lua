-- Ruby ファイルタイプの略語と設定
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    -- frozen_string_literal コメント
    vim.cmd("iabbrev <buffer> fro # frozen_string_literal: true<Esc>")

    -- YARD ドキュメントテンプレート
    vim.cmd(
      "iabbrev <buffer> yar # @param options [Type] description<CR>@return [Type] description<CR>@raise [StandardError] description<CR>@option options [Type] description<CR>@example description<CR>@yield [Type] description<Esc>6k4w"
    )

    -- RSpec context ブロック
    vim.cmd("iabbrev <buffer> con context '' do<CR>end<Esc>kw<Esc>")

    -- RSpec describe ブロック
    vim.cmd("iabbrev <buffer> des describe '' do<CR>end<Esc>kw<Esc>")

    -- RSpec let 文
    vim.cmd("iabbrev <buffer> let let(:) { }<Esc>4hi<Esc>")

    -- RSpec shared_examples ブロック
    vim.cmd("iabbrev <buffer> sha shared_examples '' do<CR>end<Esc>kw<Esc>")

    -- RSpec it_behaves_like 文
    vim.cmd("iabbrev <buffer> beh it_behaves_like ''<Esc>h<Esc>")
  end,
})

-- Markdownファイルのファイルタイプを設定
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.md",
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})

-- Markdownファイルタイプの略語と設定
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- HTMLテーブルテンプレート
    vim.cmd(
      'iabbrev <buffer> tab <table><CR><Esc>i  <thead><CR><Esc>i    <tr><CR><Esc>i      <th colspan="2"></th><CR><Esc>i    </tr><CR><Esc>i  </thead><CR><Esc>i  <tbody><CR><Esc>i    <tr><CR><Esc>i      <td></td><CR><Esc>i      <td></td><CR><Esc>i    </tr><CR><Esc>i  </tbody><CR><Esc>i</table><Esc>'
    )
  end,
})
