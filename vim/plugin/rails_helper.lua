local function execute_rspec_line()
  local file_path = vim.fn.expand("%")
  local line_number = vim.fn.line(".")

  local cmd = string.format(
    "tmux send -t $(printf ':.%%s' $(math $(tmux display-message -p '#{pane_index}') + 1)) 'docker compose exec $service_name rspec %s:%d' C-m",
    file_path,
    line_number
  )

  vim.fn.system(cmd)
end

vim.keymap.set("n", "<leader>t", execute_rspec_line, { desc = "Execute RSpec" })

local function execute_rubocop()
  local file_path = vim.fn.expand("%")

  local cmd = string.format(
    "tmux send -t $(printf ':.%%s' $(math $(tmux display-message -p '#{pane_index}') + 1)) 'docker compose exec $service_name rubocop %s' C-m",
    file_path,
    line_number
  )

  vim.fn.system(cmd)
end

vim.keymap.set("n", "<leader>r", execute_rubocop, { desc = "Execute RuboCop" })
