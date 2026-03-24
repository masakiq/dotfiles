local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

local function load_module()
  return helpers.require_with_stubs("pickers.core", {
    ["telescope.actions"] = {
      select_horizontal = "select_horizontal",
      select_vertical = "select_vertical",
      select_default = "select_default",
      move_selection_next = "move_selection_next",
      move_selection_previous = "move_selection_previous",
      preview_scrolling_down = "preview_scrolling_down",
      preview_scrolling_up = "preview_scrolling_up",
      select_all = "select_all",
      toggle_selection = "toggle_selection",
    },
    ["telescope.actions.layout"] = {
      toggle_preview = "toggle_preview",
    },
    ["pickers.actions"] = {
      open_all_with = function(command)
        return "open_all_with:" .. command
      end,
      open_first_and_send_to_qflist = function(command, opts)
        return {
          command = command,
          opts = opts,
        }
      end,
    },
  })
end

local function find_map(maps, mode, lhs)
  for _, item in ipairs(maps) do
    if item.mode == mode and item.lhs == lhs then
      return item
    end
  end

  error(string.format("Map not found: %s %s", mode, lhs))
end

T["default_config() exposes expected Telescope mappings"] = function()
  local core = load_module()
  local config = core.default_config()

  eq(config.layout_strategy, "horizontal")
  eq(config.mappings.i["<CR>"], "select_default")
  eq(config.mappings.i["<C-s>"], "select_horizontal")
  eq(config.mappings.n["<C-v>"], "select_vertical")
end

T["apply_highlights() defines Telescope highlight groups"] = function()
  local core = load_module()

  core.apply_highlights()

  eq(vim.api.nvim_get_hl(0, { name = "TelescopePreviewNormal" }).bg, 0)
  eq(vim.api.nvim_get_hl(0, { name = "TelescopePromptBorder" }).bg, 0)
end

T["chain_attach_mappings() stops at the first false return"] = function()
  local core = load_module()
  local order = {}
  local combined = core.chain_attach_mappings(function()
    table.insert(order, "first")
    return true
  end, function()
    table.insert(order, "second")
    return false
  end, function()
    table.insert(order, "third")
    return true
  end)

  eq(combined(0, function() end), false)
  eq(order, { "first", "second" })
end

T["with_file_mappings() augments mappings and preserves original attach_mappings"] = function()
  local core = load_module()
  local maps = {}
  local original_called = false
  local opts = core.with_file_mappings({
    prompt_title = "Files",
    attach_mappings = function(_, map)
      original_called = true
      map("n", "x", "original")
      return true
    end,
  })

  eq(
    opts.attach_mappings(12, function(mode, lhs, rhs)
      table.insert(maps, {
        mode = mode,
        lhs = lhs,
        rhs = rhs,
      })
    end),
    true
  )

  eq(original_called, true)
  eq(find_map(maps, "i", "<CR>").rhs, "open_all_with:tab drop")
  eq(find_map(maps, "i", "<C-e>").rhs, "open_all_with:edit")
  eq(find_map(maps, "n", "<C-s>").rhs, "open_all_with:split")
  eq(find_map(maps, "n", "<C-v>").rhs, "open_all_with:vsplit")
  eq(find_map(maps, "i", "?").rhs, "toggle_preview")
  eq(find_map(maps, "n", "<C-x>").rhs.command, "tab drop")
  eq(find_map(maps, "n", "<C-x>").rhs.opts.title, "Files")
  eq(find_map(maps, "n", "x").rhs, "original")
end

return T
