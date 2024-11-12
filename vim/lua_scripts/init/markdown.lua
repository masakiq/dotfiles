local api = vim.api

-- Function to handle Markdown file preview
local function preview_markdown()
  if vim.bo.filetype ~= 'markdown' then
    return
  end

  -- Get the current buffer's file path

  local filepath = api.nvim_buf_get_name(0)
  -- Exit if the current tab has 2 or more windows
  if vim.fn.winnr('$') > 1 then
    for i = 1, vim.fn.winnr('$') do
      local bufnr = vim.fn.winbufnr(i)
      if vim.fn.getbufvar(bufnr, '&buftype') == 'terminal' then
        print("Terminal buffer found in window " .. i)
        vim.api.nvim_buf_delete(bufnr, { force = true })
        preview_markdown()
        return
      end
    end
  end

  -- Open a vertical split
  vim.cmd('vsplit')

  -- Set the new window to a terminal running the cat command
  local term_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(term_buf)

  -- Disable line numbers in the terminal buffer
  vim.api.nvim_buf_set_option(term_buf, 'number', false)
  vim.api.nvim_buf_set_option(term_buf, 'relativenumber', false)

  -- Run glow command in the terminal buffer
  vim.fn.termopen("glow -w 0 " .. vim.fn.shellescape(filepath))
  local terminal_id = vim.api.nvim_get_current_win()

  -- Return cursor to the original buffer
  vim.cmd('wincmd p')

  -- Wait briefly before applying the cursor position to the terminal buffer
  vim.defer_fn(function()
    pcall(function()
      local original_id = vim.api.nvim_get_current_win()
      local original_pos = vim.api.nvim_win_get_cursor(original_id)
      vim.api.nvim_set_current_win(terminal_id)

      -- Get the number of lines in the terminal buffer
      local line_count = vim.api.nvim_buf_line_count(0)

      -- Ensure the cursor position is within the buffer range
      local cursor_pos = { math.min(original_pos[1], line_count), original_pos[2] }

      vim.api.nvim_win_set_cursor(terminal_id, cursor_pos)
      vim.api.nvim_set_current_win(original_id)
    end)
  end, 100)
end

-- Auto command to trigger when opening a Markdown file
api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.md",
  callback = preview_markdown,
})

vim.api.nvim_exec([[
  autocmd BufWritePost *.md silent! lua vim.cmd('PreviewMarkdown')
]], false)

-- Create Vim command to run the preview_markdown function
api.nvim_create_user_command('PreviewMarkdown', preview_markdown, {})
