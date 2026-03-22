local M = {}

local function default_find_files()
  local files = vim.fn.globpath("vim/tests", "**/*_test.lua", true, true)
  table.sort(files)
  return files
end

local function run_with_finder(find_files, opts)
  MiniTest.run(vim.tbl_deep_extend("force", {
    collect = {
      find_files = find_files,
    },
  }, opts or {}))
end

function M.run(opts)
  run_with_finder(default_find_files, opts)
end

function M.run_file(file, opts)
  run_with_finder(function()
    return { file }
  end, opts)
end

function M.run_from_env()
  local file = vim.env.MINITEST_FILE
  if file and file ~= "" then
    M.run_file(file)
    return
  end

  M.run()
end

return M
