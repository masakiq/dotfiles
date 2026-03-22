local helpers = dofile("vim/tests/helpers.lua")

local child = helpers.new_child_neovim()
local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set({
  hooks = {
    pre_case = child.setup,
    post_once = child.stop,
  },
})

local repo_root = vim.fn.getcwd()

local function set_child_global(name, value)
  child.lua(string.format("_G.%s = ...", name), { value })
end

T["ruby.lua registers ruby LSPs, command, and buffer-local mapping"] = function()
  set_child_global("phase3_repo_root", repo_root)

  local result = child.lua_get([[
    (function()
      local starts = {}
      local rubocop_calls = 0

      package.loaded["rubocop"] = {
        disable_current_line_cops = function()
          rubocop_calls = rubocop_calls + 1
        end,
      }

      vim.lsp.start = function(opts)
        table.insert(starts, opts)
      end

      vim.lsp.get_client_by_id = function()
        return {
          supports_method = function(method)
            return method == "textDocument/completion"
          end,
        }
      end

      dofile(_G.phase3_repo_root .. "/vim/plugin/lsp/ruby.lua")

      vim.api.nvim_buf_set_name(0, _G.phase3_repo_root .. "/phase3.rb")
      vim.cmd("doautocmd <nomodeline> FileType ruby")

      local mapping = vim.fn.maparg("<leader>r", "n", false, true)
      local current_buf = vim.api.nvim_get_current_buf()
      local insert_char_pre_before = #vim.api.nvim_get_autocmds({
        event = "InsertCharPre",
        buffer = current_buf,
      })

      vim.api.nvim_exec_autocmds("LspAttach", { buffer = current_buf, data = { client_id = 7 } })
      vim.cmd("RubocopDisableCurrentLineCops")

      return {
        ruby_autocmd_count = #vim.api.nvim_get_autocmds({ event = "FileType", pattern = "ruby" }),
        command_exists = vim.fn.exists(":RubocopDisableCurrentLineCops"),
        start_count = #starts,
        rubocop = starts[1],
        ruby_lsp = starts[2],
        mapping_desc = mapping.desc,
        mapping_buffer = mapping.buffer,
        rubocop_calls = rubocop_calls,
        insert_char_pre_before = insert_char_pre_before,
        insert_char_pre_after = #vim.api.nvim_get_autocmds({
          event = "InsertCharPre",
          buffer = current_buf,
        }),
      }
    end)()
  ]])

  eq(result.ruby_autocmd_count, 3)
  eq(result.command_exists, 2)
  eq(result.start_count, 2)
  eq(result.rubocop.name, "rubocop")
  eq(result.rubocop.cmd, { "rubocop", "--lsp" })
  eq(result.rubocop.root_dir, repo_root)
  eq(result.rubocop.settings.rubocop.useBundler, false)
  eq(result.rubocop.settings.rubocop.lint, true)
  eq(result.rubocop.settings.rubocop.autocorrect, true)
  eq(result.rubocop.settings.rubocop.safeAutocorrect, false)
  eq(result.ruby_lsp.name, "ruby-lsp")
  eq(result.ruby_lsp.cmd, { "ruby-lsp" })
  eq(result.ruby_lsp.root_dir, repo_root)
  eq(result.ruby_lsp.capabilities.textDocument.completion.completionItem.snippetSupport, true)
  eq(result.ruby_lsp.capabilities.textDocument.completion.completionItem.documentationFormat, {
    "markdown",
    "plaintext",
  })
  eq(result.mapping_desc, "Disable RuboCop offense on current line")
  eq(result.mapping_buffer, 1)
  eq(result.rubocop_calls, 1)
  eq(result.insert_char_pre_before, 0)
  eq(result.insert_char_pre_after, 1)
end

T["ruby.lua loads cwd .nvim.lua and skips default LSP autocmds"] = function()
  local override_root = vim.fn.tempname()
  set_child_global("phase3_repo_root", repo_root)
  set_child_global("phase3_ruby_override_root", override_root)

  local result = child.lua_get([[
    (function()
      local root = _G.phase3_ruby_override_root
      local starts = {}

      vim.fn.mkdir(root, "p")
      vim.fn.writefile({
        "_G.phase3_ruby_override_loaded = true",
      }, root .. "/.nvim.lua")

      vim.lsp.start = function(opts)
        table.insert(starts, opts)
      end

      vim.cmd("lcd " .. vim.fn.fnameescape(root))
      dofile(_G.phase3_repo_root .. "/vim/plugin/lsp/ruby.lua")

      return {
        loaded = _G.phase3_ruby_override_loaded,
        ruby_autocmd_count = #vim.api.nvim_get_autocmds({ event = "FileType", pattern = "ruby" }),
        command_exists = vim.fn.exists(":RubocopDisableCurrentLineCops"),
        start_count = #starts,
      }
    end)()
  ]])

  eq(result.loaded, true)
  eq(result.ruby_autocmd_count, 1)
  eq(result.command_exists, 2)
  eq(result.start_count, 0)
end

return T
