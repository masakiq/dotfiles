-- Tab operation functions

-- MergeTab function: Merges all buffers from current tab into vertical splits
local function merge_tab()
  local bufnums = vim.fn.tabpagebuflist()
  vim.cmd("hide tabclose")
  vim.cmd("topleft vsplit")

  for _, n in ipairs(bufnums) do
    vim.cmd("vertical sb " .. n)
    vim.cmd("wincmd _")
  end

  vim.cmd("wincmd t")
  vim.cmd("quit")
  vim.cmd("wincmd =")
end

-- SeparateTab function: Moves current buffer to a new tab
local function separate_tab()
  vim.cmd("wincmd l")
  local file = vim.fn.expand("%")
  vim.cmd("close")
  vim.cmd("tab drop " .. file)
  vim.cmd("normal! gT")
end

-- Create user commands
vim.api.nvim_create_user_command("MergeTab", merge_tab, {})
vim.api.nvim_create_user_command("SeparateTab", separate_tab, {})

vim.keymap.set("n", "<leader>m", merge_tab, { desc = "Merge Tab" })
vim.keymap.set("n", "<leader>s", separate_tab, { desc = "Separate Tab" })
