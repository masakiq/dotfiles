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

T["open_github.lua normalizes remotes and opens repo, normal, and visual URLs"] = function()
  helpers.track_editor_state({
    lua_globals = {
      "open_github",
      "repository_url",
      "commit",
      "relative_file_path",
    },
  })

  local executed = {}

  helpers.stub(io, "popen", function(command)
    if command == "git remote get-url origin" then
      return popen_result("git@github.com:masakiq/dotfiles.git\n")
    end

    if command == "git show -s --format=%H" then
      return popen_result("abc123\n")
    end

    if command == "git rev-parse --show-toplevel" then
      return popen_result("/repo\n")
    end

    error("unexpected io.popen call: " .. command)
  end)
  helpers.stub(vim.api, "nvim_exec", function()
    return "/repo/vim/init.lua"
  end)
  helpers.stub(vim.api, "nvim_win_get_cursor", function()
    return { 12, 0 }
  end)
  helpers.stub(vim.fn, "line", function(expr)
    if expr == "'<" then
      return 3
    end

    if expr == "'>" then
      return 8
    end

    return 0
  end)
  helpers.stub(os, "execute", function(command)
    table.insert(executed, command)
    return 0
  end)

  dofile("vim/plugin/open_github.lua")

  eq(repository_url(), "https://github.com/masakiq/dotfiles")
  eq(commit(), "abc123")
  eq(relative_file_path("/repo/vim/init.lua"), "/vim/init.lua")

  open_github("repo")
  open_github("normal")
  open_github("visual")

  eq(vim.fn.exists(":OpenGitHubFileNormal"), 2)
  eq(vim.fn.exists(":OpenGitHubFileVisual"), 2)
  eq(vim.fn.exists(":OpenGitHubRepo"), 2)
  eq(executed, {
    "open https://github.com/masakiq/dotfiles",
    "open https://github.com/masakiq/dotfiles/blob/abc123/vim/init.lua#L12",
    "open https://github.com/masakiq/dotfiles/blob/abc123/vim/init.lua#L3-L8",
  })
end

return T
