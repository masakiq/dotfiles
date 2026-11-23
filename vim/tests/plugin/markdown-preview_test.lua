local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["markdown-preview.lua configures the preview plugin and registers commands"] = function()
  helpers.track_editor_state({
    modules = { "markdown_preview" },
  })

  local setup_config

  helpers.with_module_stubs({
    markdown_preview = {
      setup = function(config)
        setup_config = config
      end,
    },
  }, function()
    dofile("vim/plugin/markdown-preview.lua")
  end)

  eq(setup_config.port, 8421)
  eq(setup_config.open_browser, false)
  eq(vim.fn.exists(":MarkdownPreviewGhostty"), 2)
  eq(vim.fn.exists(":MarkdownPreviewGhosttyStop"), 2)
  eq(#vim.api.nvim_get_autocmds({ group = "MarkdownPreviewAutoStart" }), 3)
end

T["markdown-preview.lua opens and closes a native Ghostty split via terminal-browser"] = function()
  helpers.track_editor_state({
    modules = { "markdown_preview" },
  })

  local notifications = helpers.track_notify()
  local system_calls = {}
  local systemlist_calls = {}
  local listed_browsers = {}

  helpers.with_module_stubs({
    markdown_preview = {
      setup = function() end,
      url = function()
        return "http://localhost:8421"
      end,
    },
  }, function()
    dofile("vim/plugin/markdown-preview.lua")
  end)

  vim.api.nvim_create_user_command("MarkdownPreview", function() end, {})
  vim.api.nvim_create_user_command("MarkdownPreviewStop", function() end, {})

  helpers.stub(vim.env, "TMUX", "/tmp/tmux-1/default,1,0")
  helpers.stub(vim.env, "TERM", "xterm-256color")
  helpers.stub(vim.env, "TERM_PROGRAM", "ghostty")

  local killed = {}
  helpers.stub(vim.uv, "kill", function(pid, signal)
    table.insert(killed, { pid, signal })
    return 0
  end)
  helpers.stub(vim.fn, "executable", function()
    return 1
  end)
  helpers.stub(vim.fn, "systemlist", function(args)
    table.insert(systemlist_calls, args)
    return { "123", "124" }
  end)
  helpers.stub(vim.fn, "system", function(args)
    table.insert(system_calls, args)

    local joined = table.concat(args, " ")
    if joined:find("terminal%-browser ls", 1, false) then
      return vim.json.encode({ browsers = listed_browsers })
    end
    if joined:find("terminal%-browser open", 1, false) then
      return "opened 42-1 (terminal-browser ls for details)"
    end
    if args[1] == "osascript" and args[3]:find("get id of every terminal", 1, true) then
      return "LIVE-PANE"
    end

    return ""
  end)

  local buf = helpers.make_scratch_buffer({ "# Hello" }, "README.md")
  vim.bo[buf].filetype = "markdown"

  vim.cmd("MarkdownPreviewGhostty")

  local open_call = system_calls[#system_calls]
  eq(open_call[1], "env")
  eq(vim.tbl_contains(open_call, "TMUX"), true)
  eq(vim.tbl_contains(open_call, "TERM_PROGRAM=ghostty"), true)
  eq(
    vim.list_slice(open_call, #open_call - 4),
    { "terminal-browser", "open", "http://localhost:8421", "--split", "right" }
  )

  listed_browsers = { { key = "42-1", pid = 42, tty = "/dev/ttys012", pane = { pane = "LIVE-PANE" } } }
  system_calls = {}

  vim.cmd("MarkdownPreviewGhosttyStop")

  local closed = false
  for _, call in ipairs(system_calls) do
    if call[1] == "osascript" and call[3] == 'tell application "Ghostty" to close terminal id "LIVE-PANE"' then
      closed = true
    end
  end
  eq(closed, true)
  eq(systemlist_calls[#systemlist_calls], { "ps", "-t", "ttys012", "-o", "pid=" })
  eq(killed, { { 123, "sigterm" }, { 124, "sigterm" } })
  eq(notifications, {})
end

T["markdown-preview.lua warns when called outside a markdown buffer"] = function()
  helpers.track_editor_state({
    modules = { "markdown_preview" },
  })

  local notifications = helpers.track_notify()

  helpers.with_module_stubs({
    markdown_preview = {
      setup = function() end,
      url = function()
        return "http://localhost:8421"
      end,
    },
  }, function()
    dofile("vim/plugin/markdown-preview.lua")
  end)

  local buf = helpers.make_scratch_buffer({ "plain" }, "plain.txt")
  vim.bo[buf].filetype = "text"

  vim.cmd("MarkdownPreviewGhostty")

  eq(notifications[#notifications].message, "Markdown file is required")
  eq(notifications[#notifications].level, vim.log.levels.WARN)
end

return T
