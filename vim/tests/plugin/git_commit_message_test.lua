local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["git_commit_message.lua starts the external pane helper when COMMIT_EDITMSG is read"] = function()
  helpers.track_editor_state()

  local jobstart_calls = {}

  helpers.stub(vim.fn, "jobstart", function(command, opts)
    table.insert(jobstart_calls, {
      command = command,
      opts = opts,
    })
    return 42
  end)

  dofile("vim/plugin/git_commit_message.lua")

  local commit_message_dir = vim.fn.tempname()
  local commit_message_path = commit_message_dir .. "/COMMIT_EDITMSG"
  vim.fn.mkdir(commit_message_dir, "p")
  vim.fn.writefile({
    "",
    "# Please enter the commit message for your changes.",
  }, commit_message_path)

  vim.cmd("edit " .. vim.fn.fnameescape(commit_message_path))
  local commit_message_bufnr = vim.api.nvim_get_current_buf()

  MiniTest.finally(function()
    if vim.api.nvim_buf_is_valid(commit_message_bufnr) then
      pcall(vim.api.nvim_buf_delete, commit_message_bufnr, { force = true })
    end
    vim.fn.delete(commit_message_dir, "rf")
  end)

  vim.api.nvim_exec_autocmds("BufReadPost", {
    pattern = "COMMIT_EDITMSG",
  })
  vim.api.nvim_exec_autocmds("BufReadPost", {
    pattern = "COMMIT_EDITMSG",
  })

  eq(jobstart_calls[1].command, "git_generate_commit_message_pane")
  eq(jobstart_calls[1].opts.cwd, vim.fn.getcwd())
  eq(jobstart_calls[1].opts.detach, true)
  eq(#jobstart_calls, 1)
  eq(vim.fn.exists(":CommitMessageGenerate"), 0)
  eq(vim.fn.exists(":CommitMessageApply"), 0)
  eq(vim.fn.exists(":CommitMessageProvider"), 0)
end

T["git_commit_message.lua warns when the external pane helper cannot be started"] = function()
  helpers.track_editor_state()

  local notifications = helpers.track_notify()

  helpers.stub(vim, "schedule", function(callback)
    callback()
  end)
  helpers.stub(vim.fn, "jobstart", function()
    return 0
  end)

  dofile("vim/plugin/git_commit_message.lua")

  local bufnr = helpers.make_scratch_buffer({
    "",
  }, ".git/COMMIT_EDITMSG")
  vim.api.nvim_set_current_buf(bufnr)

  vim.api.nvim_exec_autocmds("BufReadPost", {
    pattern = "COMMIT_EDITMSG",
  })

  eq(notifications[1].message, "Failed to start `git_generate_commit_message_pane`")
  eq(notifications[1].level, vim.log.levels.WARN)
end

return T
