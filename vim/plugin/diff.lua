local M = {}

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local core = require("pickers.core")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local function list_tabs()
  local list = {}
  local tabnumber = 1

  while tabnumber <= vim.fn.tabpagenr("$") do
    local buflist = vim.fn.tabpagebuflist(tabnumber)
    for _, buf in ipairs(buflist) do
      local file = vim.fn.expandcmd("#" .. buf)
      file = string.gsub(file, "#.*", "[No-Name]")
      table.insert(list, file)
    end
    tabnumber = tabnumber + 1
  end

  return list
end

local function diff_files(line)
  vim.cmd("vertical diffsplit " .. line)
  vim.wo.wrap = true
  vim.cmd("wincmd h")
  vim.wo.wrap = true
end

local function get_current_branch()
  local handle = io.popen("git branch --show-current 2>/dev/null")
  if handle then
    local result = handle:read("*a"):gsub("\n", "")
    handle:close()
    return result
  end
  return "main"
end

local function select_diff_files(branch)
  local current_branch = get_current_branch()
  vim.g.selected_branch = branch
  local ok, _ = pcall(function()
    vim.cmd("Gvdiff " .. vim.g.selected_branch .. "..." .. current_branch)
    vim.cmd("SwapWindow")
  end)
  if not ok then
    vim.api.nvim_echo({ { vim.v.exception, "WarningMsg" } }, true, {})
  end
end

function M.diff_file()
  local ok, _ = pcall(function()
    local picker_opts = core.default_picker_opts({
      prompt_title = "Diff Files",
      previewer = false,
      attach_mappings = function(prompt_bufnr, map)
        local function select_entry()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if selection and selection.value then
            vim.schedule(function()
              diff_files(selection.value)
            end)
          end
        end

        for _, mode in ipairs({ "i", "n" }) do
          map(mode, "<CR>", select_entry)
          map(mode, "<C-e>", select_entry)
        end

        return true
      end,
    })

    pickers
      .new(picker_opts, {
        finder = finders.new_table({
          results = list_tabs(),
        }),
        previewer = false,
        sorter = conf.generic_sorter(picker_opts),
      })
      :find()
  end)
  if not ok then
    vim.api.nvim_echo({ { vim.v.exception, "WarningMsg" } }, true, {})
  end
end

vim.api.nvim_create_user_command("DiffFile", M.diff_file, {})

return M
