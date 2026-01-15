local function get_pane_by_name(pane_name)
  -- セッション名取得と pane 検索を1つのコマンドにまとめる
  local cmd = string.format(
    "tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}:#{@pane_name}' | grep \"^$(tmux display-message -p '#{session_name}'):\" | grep ':%s$'",
    pane_name
  )
  local result = vim.fn.system(cmd):gsub("%s+", "")
  if result == "" then
    return nil
  end
  local session_window_pane = result:match("([^:]+:[^:]+)")
  return session_window_pane
end

local function get_pane_index(pane_number)
  return vim.fn.system(string.format("tmux list-panes -F '#{pane_index}' | sed -n '%dp'", pane_number)):gsub("%s+", "")
end

local function send_command_to_pane_by_name(pane_name, command)
  local pane_index = get_pane_by_name(pane_name)
  if not pane_index then
    print(string.format("Pane '%s' not found", pane_name))
    return
  end

  -- cancel と send を1つのコマンドにまとめて非同期実行
  local cmd = string.format(
    "tmux send -t %s -X cancel 2>/dev/null; tmux send -t %s '%s' C-m",
    pane_index, pane_index, command
  )
  vim.fn.jobstart(cmd, { detach = true })
end

local function send_command_to_pane(pane_offset, command)
  local target_pane =
      string.format("$(printf ':.%%s' $(math $(tmux display-message -p '#{pane_index}') + %d))", pane_offset)

  -- cancel と send を1つのコマンドにまとめて非同期実行
  local cmd = string.format(
    "tmux send -t %s -X cancel 2>/dev/null; tmux send -t %s '%s' C-m",
    target_pane, target_pane, command
  )
  vim.fn.jobstart(cmd, { detach = true })
end

local function execute_ruby_test(file_path, line_number)
  local test_target = line_number and string.format("%s:%d", file_path, line_number) or file_path
  -- clear とテストコマンドを1つにまとめる
  local cmd = string.format(
    'clear && printf "\\033[3J" && docker compose exec $service_name rspec %s && any-notifier send "🟢 Test Succeeded" || any-notifier send "❌️ Test Failed"',
    test_target
  )
  send_command_to_pane_by_name("test", cmd)
end

local function execute_ruby_format()
  send_command_to_pane_by_name(
    "format",
    'docker compose exec $service_name rubocop -A && any-notifier send "🟢 Format Succeeded" || any-notifier send "❌️ Format Failed"'
  )
end

local function execute_dart_test(file_path, line_number)
  local cmd
  if line_number then
    cmd = string.format("flutter test %s", file_path, line_number)
  else
    cmd = string.format("flutter test %s", file_path)
  end
  send_command_to_pane_by_name("test", cmd)
  vim.wait(100)
end

local function execute_dart_format()
  send_command_to_pane_by_name("test", "dart format .")
end

local function execute_test_line()
  local file_path = vim.fn.expand("%")
  local line_number = vim.fn.line(".")
  local file_ext = vim.fn.expand("%:e")

  if file_ext == "rb" then
    execute_ruby_test(file_path, line_number)
  elseif file_ext == "dart" then
    execute_dart_test(file_path, line_number)
  end
end

vim.keymap.set("n", "T", execute_test_line, { desc = "Execute Test line" })

local function execute_test()
  local file_path = vim.fn.expand("%")
  local file_ext = vim.fn.expand("%:e")

  if file_ext == "rb" then
    execute_ruby_test(file_path, nil)
  elseif file_ext == "dart" then
    execute_dart_test(file_path, nil)
    vim.wait(100)
    execute_dart_format()
  end
end

vim.keymap.set("n", "<C-t>", execute_test, { desc = "Execute Test (file)" })
