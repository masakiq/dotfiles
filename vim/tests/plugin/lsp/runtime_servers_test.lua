local helpers = dofile("vim/tests/helpers.lua")

local child = helpers.new_child_neovim()
local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set({
  hooks = {
    pre_once = child.setup,
    pre_case = child.reset,
    post_once = child.stop,
  },
})

local function set_child_global(name, value)
  child.lua(string.format("_G.%s = ...", name), { value })
end

T["dart.lua starts dartls for dart buffers"] = function()
  local root = vim.fn.tempname()
  set_child_global("phase3_dart_root", root)

  local result = child.lua_get([[
    (function()
      local root = _G.phase3_dart_root
      local starts = {}

      vim.fn.mkdir(root .. "/lib", "p")
      vim.fn.writefile({ "name: phase3" }, root .. "/pubspec.yaml")
      dofile("vim/plugin/lsp/dart.lua")

      local callback
      for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = "FileType" })) do
        if autocmd.pattern == "dart" then
          callback = autocmd.callback
          break
        end
      end

      vim.lsp.start = function(opts)
        table.insert(starts, opts)
      end

      vim.cmd("lcd " .. vim.fn.fnameescape(root .. "/lib"))
      vim.api.nvim_buf_set_name(0, root .. "/lib/main.dart")
      callback({ buf = vim.api.nvim_get_current_buf(), match = "dart" })

      return {
        has_autocmd = callback ~= nil,
        start_count = #starts,
        start = starts[1],
      }
    end)()
  ]])

  eq(result.has_autocmd, true)
  eq(result.start_count, 1)
  eq(result.start.name, "dartls")
  eq(result.start.cmd, { "dart", "language-server", "--protocol=lsp" })
  eq(result.start.filetypes, { "dart" })
  eq(result.start.root_dir, vim.loop.fs_realpath(root) or root)
  eq(result.start.settings.dart.completeFunctionCalls, true)
end

T["efm.lua starts efm with formatter settings and buffer fallback root"] = function()
  local root = vim.fn.tempname()
  set_child_global("phase3_efm_root", root)

  local result = child.lua_get([[
    (function()
      local root = _G.phase3_efm_root
      local starts = {}

      vim.fn.mkdir(root .. "/nested", "p")
      dofile("vim/plugin/lsp/efm.lua")

      local callback
      for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = "FileType" })) do
        if autocmd.pattern == "sql" then
          callback = autocmd.callback
          break
        end
      end

      vim.lsp.start = function(opts)
        table.insert(starts, opts)
      end

      vim.cmd("lcd " .. vim.fn.fnameescape(root .. "/nested"))
      vim.api.nvim_buf_set_name(0, root .. "/nested/query.sql")
      callback({ buf = vim.api.nvim_get_current_buf(), match = "sql" })

      return {
        has_sql_autocmd = callback ~= nil,
        start_count = #starts,
        start = starts[1],
      }
    end)()
  ]])

  eq(result.has_sql_autocmd, true)
  eq(result.start_count, 1)
  eq(result.start.name, "efm")
  eq(result.start.cmd, { "efm-langserver" })
  eq(result.start.root_dir, vim.loop.fs_realpath(root .. "/nested") or (root .. "/nested"))
  eq(result.start.init_options.documentFormatting, true)
  eq(result.start.init_options.documentRangeFormatting, true)
  eq(result.start.settings.languages.json[1].formatCommand, "prettier --stdin --stdin-filepath ${INPUT} --parser json")
  eq(result.start.settings.languages.yaml[1].formatCommand, "prettier --stdin-filepath ${INPUT}")
  eq(result.start.settings.languages.html[1].formatCommand, "prettier --stdin-filepath ${INPUT}")
  eq(result.start.settings.languages.markdown[1].formatCommand, "prettier --stdin-filepath ${INPUT}")
  eq(result.start.settings.languages.sql[1].formatCommand, "npx sql-formatter")
  eq(
    result.start.settings.languages.lua[1].formatCommand,
    "stylua --search-parent-directories --stdin-filepath ${INPUT} -"
  )
end

T["lua.lua starts lua_ls with runtime settings and cwd fallback root"] = function()
  local root = vim.fn.tempname()
  set_child_global("phase3_lua_root", root)

  local result = child.lua_get([[
    (function()
      local root = _G.phase3_lua_root
      local starts = {}

      vim.fn.mkdir(root .. "/nested", "p")
      vim.api.nvim_get_runtime_file = function()
        return { "/runtime/a", "/runtime/b" }
      end

      dofile("vim/plugin/lsp/lua.lua")

      local callback
      for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = "FileType" })) do
        if autocmd.pattern == "lua" then
          callback = autocmd.callback
          break
        end
      end

      vim.lsp.start = function(opts)
        table.insert(starts, opts)
      end

      vim.cmd("lcd " .. vim.fn.fnameescape(root .. "/nested"))
      vim.api.nvim_buf_set_name(0, root .. "/nested/init.lua")
      callback({ buf = vim.api.nvim_get_current_buf(), match = "lua" })

      return {
        has_autocmd = callback ~= nil,
        start_count = #starts,
        start = starts[1],
      }
    end)()
  ]])

  eq(result.has_autocmd, true)
  eq(result.start_count, 1)
  eq(result.start.name, "lua_ls")
  eq(result.start.cmd, { "lua-language-server" })
  eq(result.start.filetypes, { "lua" })
  eq(result.start.root_dir, vim.loop.fs_realpath(root .. "/nested") or (root .. "/nested"))
  eq(result.start.settings.Lua.runtime.version, "LuaJIT")
  eq(result.start.settings.Lua.diagnostics.globals, { "vim" })
  eq(result.start.settings.Lua.workspace.library, { "/runtime/a", "/runtime/b" })
  eq(result.start.settings.Lua.telemetry.enable, false)
end

T["markdown.lua starts markdown-oxide for markdown and md"] = function()
  local root = vim.fn.tempname()
  set_child_global("phase3_markdown_root", root)

  local result = child.lua_get([[
    (function()
      local root = _G.phase3_markdown_root
      local starts = {}

      vim.fn.mkdir(root .. "/notes", "p")
      vim.fn.writefile({ "# phase3" }, root .. "/README.md")
      dofile("vim/plugin/lsp/markdown.lua")

      local markdown_callback
      local md_callback
      for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = "FileType" })) do
        if autocmd.pattern == "markdown" then
          markdown_callback = autocmd.callback
        end
        if autocmd.pattern == "md" then
          md_callback = autocmd.callback
        end
      end

      vim.lsp.start = function(opts)
        table.insert(starts, opts)
      end

      vim.cmd("lcd " .. vim.fn.fnameescape(root .. "/notes"))
      vim.api.nvim_buf_set_name(0, root .. "/notes/test.md")
      markdown_callback({ buf = vim.api.nvim_get_current_buf(), match = "markdown" })

      return {
        has_markdown_autocmd = markdown_callback ~= nil,
        has_md_autocmd = md_callback ~= nil,
        start_count = #starts,
        start = starts[1],
      }
    end)()
  ]])

  eq(result.has_markdown_autocmd, true)
  eq(result.has_md_autocmd, true)
  eq(result.start_count, 1)
  eq(result.start.name, "markdown-oxide")
  eq(result.start.cmd, { "markdown-oxide" })
  eq(result.start.root_dir, vim.loop.fs_realpath(root) or root)
end

T["toml.lua starts taplo from the nearest toml root"] = function()
  local root = vim.fn.tempname()
  set_child_global("phase3_toml_root", root)

  local result = child.lua_get([[
    (function()
      local root = _G.phase3_toml_root
      local starts = {}

      vim.fn.mkdir(root .. "/nested", "p")
      vim.fn.mkdir(root .. "/.git", "p")
      dofile("vim/plugin/lsp/toml.lua")

      local callback
      for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = "FileType" })) do
        if autocmd.pattern == "toml" then
          callback = autocmd.callback
          break
        end
      end

      vim.lsp.start = function(opts)
        table.insert(starts, opts)
      end

      vim.cmd("lcd " .. vim.fn.fnameescape(root .. "/nested"))
      vim.api.nvim_buf_set_name(0, root .. "/nested/config.toml")
      callback({ buf = vim.api.nvim_get_current_buf(), match = "toml" })

      return {
        has_autocmd = callback ~= nil,
        start_count = #starts,
        start = starts[1],
      }
    end)()
  ]])

  eq(result.has_autocmd, true)
  eq(result.start_count, 1)
  eq(result.start.name, "taplo")
  eq(result.start.cmd, { "taplo", "lsp", "stdio" })
  eq(result.start.root_dir, vim.loop.fs_realpath(root) or root)
  eq(result.start.settings, {})
end

T["ts.lua starts tsserver with prettier formatters and buffer fallback root"] = function()
  local root = vim.fn.tempname()
  set_child_global("phase3_ts_root", root)

  local result = child.lua_get([[
    (function()
      local root = _G.phase3_ts_root
      local starts = {}

      vim.fn.mkdir(root .. "/app", "p")
      dofile("vim/plugin/lsp/ts.lua")

      local callback
      local jsx_callback
      for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = "FileType" })) do
        if autocmd.pattern == "typescript" then
          callback = autocmd.callback
        end
        if autocmd.pattern == "javascriptreact" then
          jsx_callback = autocmd.callback
        end
      end

      vim.lsp.start = function(opts)
        table.insert(starts, opts)
      end

      vim.cmd("lcd " .. vim.fn.fnameescape(root .. "/app"))
      vim.api.nvim_buf_set_name(0, root .. "/app/index.ts")
      callback({ buf = vim.api.nvim_get_current_buf(), match = "typescript" })

      return {
        has_ts_autocmd = callback ~= nil,
        has_jsx_autocmd = jsx_callback ~= nil,
        start_count = #starts,
        start = starts[1],
      }
    end)()
  ]])

  eq(result.has_ts_autocmd, true)
  eq(result.has_jsx_autocmd, true)
  eq(result.start_count, 1)
  eq(result.start.name, "tsserver")
  eq(result.start.cmd, { "npx", "typescript-language-server", "--stdio" })
  eq(result.start.root_dir, vim.loop.fs_realpath(root .. "/app") or (root .. "/app"))
  eq(result.start.init_options.documentFormatting, true)
  eq(result.start.init_options.documentRangeFormatting, true)
  eq(result.start.settings.languages.typescript[1].formatCommand, "prettier --stdin-filepath ${INPUT}")
  eq(result.start.settings.languages.javascript[1].formatCommand, "prettier --stdin-filepath ${INPUT}")
end

return T
