local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

local function popen_result(output)
  return {
    read = function()
      return output
    end,
    close = function() end,
  }
end

T["swagger_preview.lua starts once, reopens existing previews, and stops jobs"] = function()
  helpers.track_editor_state()

  local started = {}
  local stopped = {}
  local opened = {}

  helpers.stub(io, "popen", function(command)
    if command:match("^command %-v swagger%-ui%-watcher") then
      return popen_result("yes\n")
    end

    if command:match("^lsof %-iTCP:8766") then
      return popen_result("")
    end

    error("unexpected io.popen call: " .. command)
  end)
  helpers.stub(vim.fn, "expand", function(expr)
    if expr == "%:p" then
      return "/tmp/swagger.yaml"
    end

    return expr
  end)
  helpers.stub(vim.fn, "jobstart", function(command, opts)
    table.insert(started, {
      command = command,
      opts = opts,
    })
    return 41
  end)
  helpers.stub(vim.fn, "jobstop", function(job_id)
    table.insert(stopped, job_id)
  end)
  helpers.stub(os, "execute", function(command)
    table.insert(opened, command)
    return 0
  end)

  dofile("vim/plugin/swagger_preview.lua")

  vim.cmd("SwaggerPreview")
  vim.cmd("SwaggerPreview")
  vim.cmd("SwaggerPreviewStop")

  eq(vim.fn.exists(":SwaggerPreview"), 2)
  eq(vim.fn.exists(":SwaggerPreviewStop"), 2)
  eq(started[1].command, "swagger-ui-watcher -p 8766 -h localhost /tmp/swagger.yaml")
  eq(started[1].opts.on_stdout ~= nil, true)
  eq(opened, { "open http://localhost:8766" })
  eq(stopped, { 41 })
end

return T
