local api = vim.api

-- Function to handle Markdown file preview
local function preview_markdown()
  if vim.bo.filetype ~= 'markdown' then
    return
  end

  -- Get the current buffer's file path
  local filepath = api.nvim_buf_get_name(0)

  -- exit if the current tab has 2 or more windows
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
  vim.fn.termopen("glow " .. vim.fn.shellescape(filepath))

  -- Return cursor to the original buffer
  vim.cmd('wincmd p')
end

-- Auto command to trigger when opening a Markdown file
api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.md",
  callback = preview_markdown,
})

-- Create Vim command to run the preview_markdown function
api.nvim_create_user_command('PreviewMarkdown', preview_markdown, {})
