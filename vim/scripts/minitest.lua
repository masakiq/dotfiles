local M = {}

local source_file_overrides = {
  ["vim/lua/plugins/init.lua"] = { "vim/tests/plugins_init_test.lua" },
  ["vim/plugin/config/file_operation.lua"] = { "vim/tests/plugin/config/basic_test.lua" },
  ["vim/plugin/config/scroll.lua"] = { "vim/tests/plugin/config/basic_test.lua" },
  ["vim/plugin/config/keymaps/basic.lua"] = { "vim/tests/plugin/config/keymaps_basic_test.lua" },
  ["vim/plugin/config/keymaps/completion.lua"] = { "vim/tests/plugin/config/keymaps_basic_test.lua" },
  ["vim/plugin/config/keymaps/surround.lua"] = { "vim/tests/plugin/config/keymaps_basic_test.lua" },
  ["vim/plugin/config/keymaps/clipboard.lua"] = { "vim/tests/plugin/config/keymaps_clipboard_test.lua" },
  ["vim/plugin/config/keymaps/functions.lua"] = { "vim/tests/plugin/config/keymaps_clipboard_test.lua" },
  ["vim/plugin/config/keymaps/move.lua"] = { "vim/tests/plugin/config/keymaps_navigation_test.lua" },
  ["vim/plugin/config/keymaps/quickfix.lua"] = { "vim/tests/plugin/config/keymaps_navigation_test.lua" },
  ["vim/plugin/config/keymaps/tab.lua"] = { "vim/tests/plugin/config/keymaps_navigation_test.lua" },
  ["vim/plugin/config/keymaps/terminal.lua"] = { "vim/tests/plugin/config/keymaps_navigation_test.lua" },
  ["vim/plugin/config/keymaps/window.lua"] = { "vim/tests/plugin/config/keymaps_navigation_test.lua" },
  ["vim/plugin/lsp/dart.lua"] = { "vim/tests/plugin/lsp/runtime_servers_test.lua" },
  ["vim/plugin/lsp/efm.lua"] = { "vim/tests/plugin/lsp/runtime_servers_test.lua" },
  ["vim/plugin/lsp/lua.lua"] = { "vim/tests/plugin/lsp/runtime_servers_test.lua" },
  ["vim/plugin/lsp/markdown.lua"] = { "vim/tests/plugin/lsp/runtime_servers_test.lua" },
  ["vim/plugin/lsp/toml.lua"] = { "vim/tests/plugin/lsp/runtime_servers_test.lua" },
  ["vim/plugin/lsp/ts.lua"] = { "vim/tests/plugin/lsp/runtime_servers_test.lua" },
}

local source_dir_overrides = {
  ["vim/lua/plugins"] = { "vim/tests/plugins_init_test.lua" },
  ["vim/plugin/config/keymaps"] = {
    "vim/tests/plugin/config/keymaps_basic_test.lua",
    "vim/tests/plugin/config/keymaps_clipboard_test.lua",
    "vim/tests/plugin/config/keymaps_navigation_test.lua",
  },
}

local source_file_prefixes = {
  { source = "vim/lua/commands", test = "vim/tests/commands" },
  { source = "vim/lua/config", test = "vim/tests/config" },
  { source = "vim/lua/pickers", test = "vim/tests/pickers" },
  { source = "vim/lua/selectors", test = "vim/tests/selectors" },
  { source = "vim/plugin/config", test = "vim/tests/plugin/config" },
  { source = "vim/plugin/lsp", test = "vim/tests/plugin/lsp" },
  { source = "vim/lua", test = "vim/tests" },
  { source = "vim", test = "vim/tests" },
}

local source_dir_prefixes = {
  { source = "vim/lua/commands", test = "vim/tests/commands" },
  { source = "vim/lua/config", test = "vim/tests/config" },
  { source = "vim/lua/pickers", test = "vim/tests/pickers" },
  { source = "vim/lua/selectors", test = "vim/tests/selectors" },
  { source = "vim/plugin/config", test = "vim/tests/plugin/config" },
  { source = "vim/plugin/lsp", test = "vim/tests/plugin/lsp" },
}

local file_profile_overrides = {}

local function starts_with(text, prefix)
  return text:sub(1, #prefix) == prefix
end

local function path_type(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type or nil
end

local function is_file(path)
  return path_type(path) == "file"
end

local function is_directory(path)
  return path_type(path) == "directory"
end

local function normalize_path(path)
  local cwd_prefix = vim.fn.getcwd() .. "/"

  path = path:gsub("/+$", "")
  path = path:gsub("^%./", "")

  if starts_with(path, cwd_prefix) then
    return path:sub(#cwd_prefix + 1)
  end

  return path
end

local function default_find_files()
  local files = vim.fn.globpath("vim/tests", "**/*_test.lua", true, true)
  table.sort(files)
  return files
end

local function collect_test_files(root)
  local files = vim.fn.globpath(root, "**/*_test.lua", true, true)
  table.sort(files)
  return files
end

local function detect_file_profile(file)
  if file_profile_overrides[file] then
    return file_profile_overrides[file]
  end

  local lines = vim.fn.readfile(file)
  local body = table.concat(lines, "\n")

  if body:find("new_child_neovim", 1, true) then
    return "slow"
  end

  return "fast"
end

local function filter_files_by_profile(files, profile)
  if profile == nil or profile == "" then
    return files
  end

  local filtered = {}

  for _, file in ipairs(files) do
    if detect_file_profile(file) == profile then
      table.insert(filtered, file)
    end
  end

  return filtered
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

function M.run_files(files, opts)
  run_with_finder(function()
    return files
  end, opts)
end

function M.run_file(file, opts)
  M.run_files({ file }, opts)
end

local function resolve_source_file(target)
  if source_file_overrides[target] then
    return source_file_overrides[target]
  end

  for _, prefix in ipairs(source_file_prefixes) do
    if starts_with(target, prefix.source .. "/") then
      local relative = target:sub(#prefix.source + 2)
      local test_file = prefix.test .. "/" .. relative:gsub("%.lua$", "_test.lua")

      if is_file(test_file) then
        return { test_file }
      end
    end
  end

  return nil
end

local function resolve_source_directory(target)
  if source_dir_overrides[target] then
    return source_dir_overrides[target]
  end

  for _, prefix in ipairs(source_dir_prefixes) do
    if target == prefix.source or starts_with(target, prefix.source .. "/") then
      local suffix = target == prefix.source and "" or target:sub(#prefix.source + 2)
      local test_dir = suffix == "" and prefix.test or (prefix.test .. "/" .. suffix)

      if is_directory(test_dir) then
        return collect_test_files(test_dir)
      end
    end
  end

  return nil
end

local function resolve_target(target)
  target = normalize_path(target)

  if target == "" then
    return nil
  end

  if is_file(target) then
    if target:match("_test%.lua$") then
      return { target }
    end

    return resolve_source_file(target)
  end

  if is_directory(target) then
    if target == "vim/tests" or starts_with(target, "vim/tests/") then
      return collect_test_files(target)
    end

    return resolve_source_directory(target)
  end

  return resolve_source_file(target)
end

function M.run_from_env()
  local target = vim.env.MINITEST_TARGET or vim.env.MINITEST_FILE
  local profile = vim.env.MINITEST_PROFILE

  if target and target ~= "" then
    local files = resolve_target(target)
    files = filter_files_by_profile(files or {}, profile)

    if not files or vim.tbl_isempty(files) then
      error(("No tests matched target/profile: %s (%s)"):format(target, profile or "all"))
    end

    M.run_files(files)
    return
  end

  if profile and profile ~= "" then
    local files = filter_files_by_profile(default_find_files(), profile)

    if vim.tbl_isempty(files) then
      error(("No tests matched profile: %s"):format(profile))
    end

    M.run_files(files)
    return
  end

  M.run()
end

return M
