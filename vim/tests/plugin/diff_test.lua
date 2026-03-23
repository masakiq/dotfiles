local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["diff.lua builds a picker and diffs the selected tab entry"] = function()
  helpers.track_editor_state({
    modules = {
      "pickers.core",
      "telescope.actions",
      "telescope.actions.state",
      "telescope.config",
      "telescope.finders",
      "telescope.pickers",
    },
  })

  local picker_opts
  local finder_results
  local mappings = {}
  local commands = {}
  local closed_prompt

  helpers.stub(vim, "schedule", function(callback)
    callback()
  end)
  helpers.stub(vim, "cmd", function(command)
    table.insert(commands, command)
  end)
  helpers.stub(vim.fn, "tabpagenr", function(expr)
    if expr == "$" then
      return 2
    end

    return 1
  end)
  helpers.stub(vim.fn, "tabpagebuflist", function(tabpage)
    if tabpage == 1 then
      return { 11 }
    end

    return { 22 }
  end)
  helpers.stub(vim.fn, "expandcmd", function(expr)
    if expr == "#11" then
      return "app/models/user.rb"
    end

    return "README.md"
  end)

  local module = helpers.with_module_stubs({
    ["pickers.core"] = {
      default_picker_opts = function(opts)
        picker_opts = opts
        return opts
      end,
    },
    ["telescope.actions"] = {
      close = function(prompt_bufnr)
        closed_prompt = prompt_bufnr
      end,
    },
    ["telescope.actions.state"] = {
      get_selected_entry = function()
        return { value = "README.md" }
      end,
    },
    ["telescope.config"] = {
      values = {
        generic_sorter = function()
          return "sorter"
        end,
      },
    },
    ["telescope.finders"] = {
      new_table = function(opts)
        finder_results = opts.results
        return opts
      end,
    },
    ["telescope.pickers"] = {
      new = function(_, spec)
        return {
          find = function()
            spec.finder = spec.finder
          end,
        }
      end,
    },
  }, function()
    return dofile("vim/plugin/diff.lua")
  end)

  eq(vim.fn.exists(":DiffFile"), 2)

  module.diff_file()
  picker_opts.attach_mappings(17, function(mode, lhs, callback)
    mappings[mode .. lhs] = callback
  end)
  mappings["i<CR>"]()

  eq(finder_results, { "app/models/user.rb", "README.md" })
  eq(closed_prompt, 17)
  eq(commands, {
    "vertical diffsplit README.md",
    "wincmd h",
  })
end

return T
