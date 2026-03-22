local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

local function load_module()
  local state = {}

  local module = helpers.require_with_stubs("pickers.files", {
    ["telescope.builtin"] = {
      find_files = function(opts)
        state.find_files_opts = opts
      end,
    },
    ["telescope.config"] = {
      values = {
        file_previewer = function(opts)
          state.file_previewer_opts = opts
          return "file_previewer"
        end,
        file_sorter = function(opts)
          state.file_sorter_opts = opts
          return "file_sorter"
        end,
      },
    },
    ["telescope.finders"] = {
      new_oneshot_job = function(command, opts)
        state.job = {
          command = command,
          opts = opts,
        }
        return "finder"
      end,
    },
    ["telescope.pickers"] = {
      new = function(opts, spec)
        state.picker = {
          opts = opts,
          spec = spec,
        }

        return {
          find = function()
            state.find_called = true
          end,
        }
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

T["build_rg_file_command() assembles rg invocation deterministically"] = function()
  local files = load_module()

  eq(files.build_rg_file_command({}), {
    "rg",
    "--hidden",
    "--files",
    "--glob",
    "!**/.git/**",
  })

  eq(
    files.build_rg_file_command({
      include_ignored = true,
      sort = "path",
      search_dirs = "vim/lua",
    }),
    {
      "rg",
      "--hidden",
      "--files",
      "--glob",
      "!**/.git/**",
      "--no-ignore",
      "--sort",
      "path",
      "vim/lua",
    }
  )
end

T["find_files() forwards normalized opts to telescope.builtin.find_files"] = function()
  local files, state = load_module()

  files.find_files({
    prompt_title = "Files",
    hidden = false,
  })

  eq(state.find_files_opts.prompt_title, "Files")
  eq(state.find_files_opts.hidden, false)
  eq(state.find_files_opts.follow, false)
  eq(state.find_files_opts.with_file_mappings, true)
end

T["rg_files() builds oneshot job picker"] = function()
  local files, state = load_module()

  files.rg_files({
    prompt_title = "Files",
    search_dirs = "vim/lua",
    sort = "path",
    cwd = "/tmp/project",
  })

  eq(state.job.command, {
    "rg",
    "--hidden",
    "--files",
    "--glob",
    "!**/.git/**",
    "--sort",
    "path",
    "vim/lua",
  })
  eq(state.job.opts.cwd, "/tmp/project")
  eq(state.picker.spec.finder, "finder")
  eq(state.picker.spec.previewer, "file_previewer")
  eq(state.picker.spec.sorter, "file_sorter")
  eq(state.find_called, true)
end

return T
