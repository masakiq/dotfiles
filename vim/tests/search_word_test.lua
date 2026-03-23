local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

local function load_module()
  local state = {
    maps = {},
  }

  local module = helpers.require_with_stubs("search_word", {
    ["commands.pickers"] = {
      search_word = function(...)
        state.search_args = { ... }
      end,
    },
    ["nui.input"] = function(opts, config)
      state.opts = opts
      state.config = config

      return {
        mount = function()
          state.mounted = true
        end,
        unmount = function()
          state.unmounted = (state.unmounted or 0) + 1
        end,
        map = function(_, mode, lhs, rhs, map_opts)
          table.insert(state.maps, {
            mode = mode,
            lhs = lhs,
            rhs = rhs,
            opts = map_opts,
          })
        end,
      }
    end,
  })

  return module, state
end

T["search_word() builds input UI and forwards submitted values"] = function()
  local search_word, state = load_module()

  search_word.search_word("app/models", "path")

  eq(state.mounted, true)
  eq(state.opts.border.text.top, " Search in models (or Find Files) ")

  state.config.on_submit("needle")

  eq(state.search_args, { "needle", "app/models", "path" })

  for _, mapping in ipairs(state.maps) do
    mapping.rhs()
  end

  eq(state.unmounted, 4)
end

T["search_word() falls back to Current Directory title"] = function()
  local search_word, state = load_module()

  search_word.search_word()

  eq(state.opts.border.text.top, " Search in Current Directory (or Find Files) ")
end

return T
