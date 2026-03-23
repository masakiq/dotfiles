local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["markdown-preview.lua configures the preview plugin and drives iTerm commands"] = function()
  helpers.track_editor_state({
    modules = { "markdown_preview" },
  })

  local notifications = helpers.track_notify()
  local setup_config
  local systemlist_calls = {}
  local preview_commands = {}

  helpers.with_module_stubs({
    markdown_preview = {
      setup = function(config)
        setup_config = config
      end,
      url = function()
        return "http://localhost:8421"
      end,
    },
  }, function()
    dofile("vim/plugin/markdown-preview.lua")
  end)

  vim.api.nvim_create_user_command("MarkdownPreview", function()
    table.insert(preview_commands, "start")
  end, {})
  vim.api.nvim_create_user_command("MarkdownPreviewStop", function()
    table.insert(preview_commands, "stop")
  end, {})

  helpers.stub(vim.fn, "systemlist", function(args)
    table.insert(systemlist_calls, args)

    if args[#args] == "http://localhost:8421" then
      return { "session-1" }
    end

    return { "closed" }
  end)

  local buf = helpers.make_scratch_buffer({ "# Hello" }, "README.md")
  vim.bo[buf].filetype = "markdown"

  vim.cmd("MarkdownPreviewITerm")
  vim.cmd("MarkdownPreviewITermStop")

  eq(setup_config.port, 8421)
  eq(setup_config.open_browser, false)
  eq(vim.fn.exists(":MarkdownPreviewITerm"), 2)
  eq(vim.fn.exists(":MarkdownPreviewITermStop"), 2)
  eq(#vim.api.nvim_get_autocmds({ group = "MarkdownPreviewAutoStart" }), 3)
  eq(preview_commands, { "start", "stop" })
  eq(systemlist_calls[1][#systemlist_calls[1]], "http://localhost:8421")
  eq(systemlist_calls[2][#systemlist_calls[2]], "session-1")
  eq(#notifications, 0)
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

  vim.cmd("MarkdownPreviewITerm")

  eq(notifications[#notifications].message, "Markdown file is required")
  eq(notifications[#notifications].level, vim.log.levels.WARN)
end

return T
