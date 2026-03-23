local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local match = helpers.expect.match
local new_set = MiniTest.new_set

local T = new_set()

T["git_commit_message.lua reports and normalizes the configured provider"] = function()
  helpers.track_editor_state({
    globals = { "git_commit_message_provider" },
  })

  local notifications = helpers.track_notify()

  helpers.stub(vim, "schedule", function(callback)
    callback()
  end)

  vim.g.git_commit_message_provider = "CODEX"
  dofile("vim/plugin/git_commit_message.lua")

  vim.cmd("CommitMessageProvider")
  vim.cmd("CommitMessageProvider invalid")

  eq(vim.g.git_commit_message_provider, "codex")
  eq(vim.fn.exists(":CommitMessageGenerate"), 2)
  eq(vim.fn.exists(":CommitMessageApply"), 2)
  eq(vim.fn.exists(":CommitMessageProvider"), 2)
  eq(notifications[1].message, "Commit message provider: codex")
  eq(notifications[2].message, "Unknown commit message provider: invalid")
  eq(notifications[2].level, vim.log.levels.WARN)
end

T["git_commit_message.lua generates a preview and applies the suggested subject"] = function()
  helpers.track_editor_state({
    globals = { "git_commit_message_provider" },
  })

  local notifications = helpers.track_notify()
  local system_calls = {}

  helpers.stub(vim, "schedule", function(callback)
    callback()
  end)
  helpers.stub(vim.fn, "executable", function(command)
    if command == "codex" then
      return 1
    end

    return 0
  end)
  helpers.stub(vim, "system", function(cmd, opts, on_exit)
    table.insert(system_calls, {
      cmd = cmd,
      opts = opts,
    })

    if cmd[1] == "git" then
      on_exit({
        code = 0,
        stdout = "diff --git a/vim/init.lua b/vim/init.lua\n+require('tests')\n",
        stderr = "",
      })
      return
    end

    on_exit({
      code = 0,
      stdout = "```text\n- test(vim): add plugin wrapper coverage\n```",
      stderr = "",
    })
  end)

  vim.g.git_commit_message_provider = "codex"
  dofile("vim/plugin/git_commit_message.lua")

  local source_buf = helpers.make_scratch_buffer({
    "",
    "",
    "# Please enter the commit message for your changes.",
  }, ".git/COMMIT_EDITMSG")
  vim.bo[source_buf].filetype = "gitcommit"
  vim.api.nvim_set_current_buf(source_buf)

  vim.cmd("CommitMessageGenerate")

  local preview_buf = vim.b[source_buf].commit_message_preview_bufnr
  local preview_lines = vim.api.nvim_buf_get_lines(preview_buf, 0, -1, false)

  vim.cmd("CommitMessageApply")

  eq(system_calls[1].cmd, { "git", "diff", "--staged", "--no-ext-diff" })
  eq(system_calls[2].cmd[1], "codex")
  match(system_calls[2].opts.stdin, "Staged diff:")
  eq(preview_lines[1], "test(vim): add plugin wrapper coverage")
  eq(preview_lines[3], "# Provider: Codex")
  eq(vim.api.nvim_buf_get_lines(source_buf, 0, 2, false), {
    "test(vim): add plugin wrapper coverage",
    "",
  })
  eq(notifications[#notifications].message, "Applied commit message suggestion")
end

return T
