-- claudecode.nvim initial setup
-- Integration plugin for Claude Code CLI and Neovim

-- Check if plugin is installed
local ok, claudecode = pcall(require, "claudecode")
if not ok then
  vim.notify("claudecode.nvim plugin not found", vim.log.levels.WARN)
  return
end

-- Plugin configuration
claudecode.setup({
  -- WebSocket server port range
  port_range = { min = 10000, max = 65535 },

  -- Automatically start WebSocket server when plugin loads
  auto_start = true,

  -- Custom command for launching Claude
  -- Uses "claude" by default if nil
  terminal_cmd = nil,

  -- Log level (trace, debug, info, warn, error)
  log_level = "warn",

  -- Send selection updates to Claude
  track_selection = true,

  -- Delay for deselection after visual mode ends (milliseconds)
  visual_demotion_delay_ms = 50,

  -- Diff display settings
  diff_provider = "auto",        -- "auto", "native", or "diffview"
  diff_opts = {
    auto_close_on_accept = true, -- Automatically close diff when changes are accepted
    show_diff_stats = true,      -- Show diff statistics
    vertical_split = true,       -- Display diff in vertical split
    open_in_current_tab = true,  -- Open diff in current tab instead of new tab
  },

  -- Terminal integration settings
  terminal = {
    split_side = "right",             -- Split position ("left" or "right")
    split_width_percentage = 0.5,     -- Percentage of editor width (0.0-1.0)
    provider = "native",              -- "snacks" or "native"
    show_native_term_exit_tip = true, -- Show native terminal exit tip
  },
})

-- Key mapping configuration
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Claude Code related key mappings
keymap(
  { "n", "v" },
  "<leader>ac",
  "<cmd>ClaudeCode<cr>",
  vim.tbl_extend("force", opts, { desc = "Toggle Claude Terminal" })
)

keymap(
  { "v" },
  "<leader>ak",
  "<cmd>ClaudeCodeSend<cr>",
  vim.tbl_extend("force", opts, { desc = "Send selection to Claude Code" })
)

keymap(
  { "n", "v" },
  "<leader>ao",
  "<cmd>ClaudeCodeOpen<cr>",
  vim.tbl_extend("force", opts, { desc = "Open/Focus Claude Terminal" })
)

keymap(
  { "n", "v" },
  "<leader>ax",
  "<cmd>ClaudeCodeClose<cr>",
  vim.tbl_extend("force", opts, { desc = "Close Claude Terminal" })
)

-- Convenient key mappings for diff mode
keymap("n", "]c", "]c", { desc = "Go to next change" })
keymap("n", "[c", "[c", { desc = "Go to previous change" })
keymap("n", "<leader>dq", "<cmd>wincmd q<cr>", vim.tbl_extend("force", opts, { desc = "Exit diff mode" }))
keymap("n", "<leader>da", "<cmd>%diffget<cr>", vim.tbl_extend("force", opts, { desc = "Accept all changes" }))

-- User command definition
vim.api.nvim_create_user_command("ClaudeCodeStatus", function()
  local status = claudecode.status()
  vim.notify("Claude Code Status: " .. vim.inspect(status), vim.log.levels.INFO)
end, { desc = "Check Claude Code status" })

-- Auto command configuration
vim.api.nvim_create_augroup("ClaudeCodeConfig", { clear = true })

-- Stop WebSocket server when Neovim exits
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = "ClaudeCodeConfig",
  callback = function()
    claudecode.stop()
  end,
  desc = "Stop Claude Code WebSocket server when Neovim exits",
})

-- Plugin loading completion message
vim.notify("claudecode.nvim successfully configured", vim.log.levels.INFO)

vim.api.nvim_set_keymap("n", "<space>oj", "<cmd>ClaudeCode<CR>", { noremap = true, silent = false })
