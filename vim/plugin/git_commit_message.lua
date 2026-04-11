-- Run the external commit-message helper as soon as Git's commit message file is read.

local group = vim.api.nvim_create_augroup("GitCommitMessagePane", { clear = true })

local function run_commit_message_pane(bufnr)
  if vim.b[bufnr].git_generate_commit_message_pane_started then
    return
  end

  vim.b[bufnr].git_generate_commit_message_pane_started = true

  vim.cmd([[exe "vsplit | term git_generate_commit_message" | wincmd p]])
end

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  pattern = "COMMIT_EDITMSG",
  callback = function(args)
    run_commit_message_pane(args.buf)
  end,
})
