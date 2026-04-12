local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

local function load_module()
  local state = {}

  local module = helpers.require_with_stubs("pickers.grep", {
    ["telescope.builtin"] = {
      grep_string = function(opts)
        state.grep_string_opts = opts
      end,
      live_grep = function(opts)
        state.live_grep_opts = opts
      end,
    },
    ["pickers.core"] = {
      default_picker_opts = function(opts)
        return vim.tbl_deep_extend("force", { from_core = true }, opts or {})
      end,
      with_file_mappings = function(opts)
        opts.with_file_mappings = true
        return opts
      end,
    },
  })

  return module, state
end

T["grep_string() normalizes search dirs without extra fixed-string args"] = function()
  local grep, state = load_module()

  grep.grep_string({
    search = "TODO",
    search_dirs = "vim/lua",
    sort = "path",
  })

  eq(state.grep_string_opts.search, "TODO")
  eq(state.grep_string_opts.search_dirs, { "vim/lua" })
  eq(state.grep_string_opts.additional_args(), {
    "--sort",
    "path",
  })
  eq(state.grep_string_opts.with_file_mappings, true)
end

T["live_grep() keeps fixed-string mode enabled by default"] = function()
  local grep, state = load_module()

  grep.live_grep({
    search_dirs = { "vim/lua" },
  })

  eq(state.live_grep_opts.search_dirs, { "vim/lua" })
  eq(state.live_grep_opts.additional_args(), {
    "--fixed-strings",
  })
  eq(state.live_grep_opts.with_file_mappings, true)
end

T["live_grep() respects disabled fixed-string mode"] = function()
  local grep, state = load_module()

  grep.live_grep({
    search_dirs = { "vim/lua", "vim/plugin" },
    fixed_strings = false,
    sort = "modified",
  })

  eq(state.live_grep_opts.search_dirs, { "vim/lua", "vim/plugin" })
  eq(state.live_grep_opts.additional_args(), {
    "--sortr",
    "modified",
  })
  eq(state.live_grep_opts.with_file_mappings, true)
end

return T
