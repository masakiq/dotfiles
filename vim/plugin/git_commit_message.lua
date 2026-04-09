-- Run the external commit-message helper as soon as Git's commit message file is read.

local group = vim.api.nvim_create_augroup("GitCommitMessagePane", { clear = true })
local command = "git_generate_commit_message_pane"

local function notify(message, level)
  vim.schedule(function()
    vim.notify(message, level or vim.log.levels.INFO)
  end)
end

local function run_commit_message_pane(bufnr)
  if vim.b[bufnr].git_generate_commit_message_pane_started then
    return
  end

  vim.b[bufnr].git_generate_commit_message_pane_started = true

  local job_id = vim.fn.jobstart(command, {
    cwd = vim.fn.getcwd(),
    detach = true,
  })

  if job_id <= 0 then
    notify("Failed to start `" .. command .. "`", vim.log.levels.WARN)
  end
end

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  pattern = "COMMIT_EDITMSG",
  callback = function(args)
    run_commit_message_pane(args.buf)
  end,
})
