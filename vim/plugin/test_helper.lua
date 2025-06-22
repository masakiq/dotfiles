local function get_pane_index(pane_number)
  return vim.fn.system(string.format("tmux list-panes -F '#{pane_index}' | sed -n '%dp'", pane_number)):gsub("%s+", "")
end

local function send_command_to_pane(pane_offset, command)
  local cmd = string.format(
    "tmux send -t $(printf ':.%%s' $(math $(tmux display-message -p '#{pane_index}') + %d)) '%s' C-m",
    pane_offset,
    command
  )
  vim.fn.system(cmd)
end

local function execute_ruby_test(file_path, line_number)
  local test_pane = get_pane_index(2)
  if test_pane ~= "" then
    local cmd = string.format("docker compose exec $service_name rspec %s:%d", file_path, line_number)
    send_command_to_pane(1, cmd)
  end

  vim.wait(500)

  local linter_pane = get_pane_index(3)
  if linter_pane ~= "" then
    send_command_to_pane(2, "docker compose exec $service_name rubocop")
  end
end

local function execute_dart_test(file_path, line_number)
  local test_pane = get_pane_index(2)
  if test_pane ~= "" then
    local cmd = string.format("flutter test %s", file_path, line_number)
    send_command_to_pane(1, cmd)
  end

  vim.wait(500)

  local linter_pane = get_pane_index(3)
  if linter_pane ~= "" then
    local cmd = string.format("dart format .")
    send_command_to_pane(2, cmd)
  end
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

vim.keymap.set("n", "<leader>t", execute_test_line, { desc = "Execute Test" })

local function execute_linter()
  local file_path = vim.fn.expand("%")
  local file_ext = vim.fn.expand("%:e")

  if file_ext == "rb" then
    local cmd = string.format(
      "tmux send -t $(printf ':.%%s' $(math $(tmux display-message -p '#{pane_index}') + 1)) 'docker compose exec $service_name rubocop %s' C-m",
      file_path
    )
    vim.fn.system(cmd)
  elseif file_ext == "dart" then
    local cmd = string.format(
      "tmux send -t $(printf ':.%%s' $(math $(tmux display-message -p '#{pane_index}') + 1)) 'flutter analyze %s' C-m",
      file_path
    )
    vim.fn.system(cmd)
  end
end

vim.keymap.set("n", "<leader>r", execute_linter, { desc = "Execute Linter" })
