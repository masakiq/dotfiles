local function get_pane_index(pane_number)
  return vim.fn.system(string.format("tmux list-panes -F '#{pane_index}' | sed -n '%dp'", pane_number)):gsub("%s+", "")
end

local function send_command_to_pane(pane_offset, command)
  local target_pane =
      string.format("$(printf ':.%%s' $(math $(tmux display-message -p '#{pane_index}') + %d))", pane_offset)

  -- Cancel copy-mode first
  local cancel_cmd = string.format("tmux send -t %s -X cancel", target_pane)
  vim.fn.system(cancel_cmd)

  -- Send the actual command
  local cmd = string.format("tmux send -t %s '%s' C-m", target_pane, command)
  vim.fn.system(cmd)
end

local function execute_ruby_test(pane_index, file_path, line_number)
  local test_pane = get_pane_index(pane_index)
  if test_pane ~= "" then
    local test_target = line_number and string.format("%s:%d", file_path, line_number) or file_path
    local cmd = string.format(
      'docker compose exec $service_name rspec %s && any-notifier send "🟢 Test Succeeded" || any-notifier send "❌️ Test Failed" --sound Ping',
      test_target
    )
    send_command_to_pane(test_pane - 1, cmd)
  end
end

local function execute_ruby_format(pane_index, file_path)
  local linter_pane = get_pane_index(pane_index)
  if linter_pane ~= "" then
    send_command_to_pane(
      linter_pane - 1,
      'docker compose exec $service_name rubocop -A && any-notifier send "🟢 Format Succeeded" || any-notifier send "❌️ Format Failed" --sound Ping'
    )
  end
end

local function execute_dart_test(pane_index, file_path, line_number)
  local test_pane = get_pane_index(pane_index)
  if test_pane ~= "" then
    local cmd
    if line_number then
      cmd = string.format("flutter test %s", file_path, line_number)
    else
      cmd = string.format("flutter test %s", file_path)
    end
    send_command_to_pane(pane_index - 1, cmd)
  end

  vim.wait(100)
end

local function execute_dart_format(pane_index, file_path)
  local linter_pane = get_pane_index(pane_index)
  if linter_pane ~= "" then
    local cmd = string.format("dart format .")
    send_command_to_pane(pane_index - 1, cmd)
  end
end

local function execute_test_line()
  local file_path = vim.fn.expand("%")
  local line_number = vim.fn.line(".")
  local file_ext = vim.fn.expand("%:e")

  if file_ext == "rb" then
    execute_ruby_test(3, file_path, line_number)
  elseif file_ext == "dart" then
    execute_dart_test(3, file_path, line_number)
  end
end

vim.keymap.set("n", "<leader>t", execute_test_line, { desc = "Execute Test" })

local function execute_test()
  local file_path = vim.fn.expand("%")
  local file_ext = vim.fn.expand("%:e")

  if file_ext == "rb" then
    execute_ruby_test(3, file_path, nil)
    vim.wait(100)
    execute_ruby_format(4, file_path)
  elseif file_ext == "dart" then
    execute_dart_test(3, file_path, nil)
    vim.wait(100)
    execute_dart_format(4, file_path)
  end
end

vim.keymap.set("n", "<C-t>", execute_test, { desc = "Execute Test" })
