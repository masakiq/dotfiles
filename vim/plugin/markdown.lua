local api = vim.api

vim.g.preview_markdown_enabled = false

-- Function to handle Markdown file preview
local function preview_markdown()
  if not vim.g.preview_markdown_enabled then
    return
  end

  if vim.bo.filetype ~= "markdown" then
    return
  end

  -- Get the current buffer's file path

  local filepath = api.nvim_buf_get_name(0)
  -- Check if preview for this file already exists
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local success, result = pcall(function()
      local is_md_preview = vim.api.nvim_buf_get_var(buf, "is_markdown_preview")
      local md_file_path = vim.api.nvim_buf_get_var(buf, "markdown_file_path")
      return { is_preview = is_md_preview, file_path = md_file_path }
    end)

    if success and result.is_preview and result.file_path == filepath then
      -- Preview already exists for this file, just refresh it
      vim.api.nvim_buf_delete(buf, { force = true })
      break
    end
  end

  -- Exit if the current tab has 2 or more windows (excluding the preview we just deleted)
  if vim.fn.winnr("$") > 1 then
    for i = 1, vim.fn.winnr("$") do
      local bufnr = vim.fn.winbufnr(i)
      if vim.fn.getbufvar(bufnr, "&buftype") == "terminal" then
        print("Terminal buffer found in window " .. i)
        vim.api.nvim_buf_delete(bufnr, { force = true })
        preview_markdown()
        return
      end
    end
  end

  -- Open a vertical split
  vim.cmd("vsplit")

  -- Set the new window to a terminal running the cat command
  local term_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(term_buf)

  -- Disable line numbers in the terminal buffer
  vim.api.nvim_buf_set_option(term_buf, "number", false)
  vim.api.nvim_buf_set_option(term_buf, "relativenumber", false)

  -- Mark this buffer as a markdown preview buffer and associate with the file path
  vim.api.nvim_buf_set_var(term_buf, "is_markdown_preview", true)
  vim.api.nvim_buf_set_var(term_buf, "markdown_file_path", filepath)

  -- Get the terminal window ID before creating termopen
  local terminal_id = vim.api.nvim_get_current_win()

  -- Run slides command in the terminal buffer
  vim.fn.termopen("slides --output stdout " .. vim.fn.shellescape(filepath), {
    on_exit = function()
      -- Wait a bit for the process message to appear, then remove it
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(term_buf) then
          local current_win = vim.api.nvim_get_current_win()
          vim.api.nvim_set_current_win(terminal_id)

          -- Find and delete any line containing "Process exited"
          local lines = vim.api.nvim_buf_get_lines(term_buf, 0, -1, false)
          local filtered_lines = {}
          for _, line in ipairs(lines) do
            if not string.match(line, "%[Process exited") then
              table.insert(filtered_lines, line)
            end
          end

          -- Temporarily make buffer modifiable to update content
          vim.api.nvim_buf_set_option(term_buf, "modifiable", true)
          vim.api.nvim_buf_set_lines(term_buf, 0, -1, false, filtered_lines)
          vim.api.nvim_buf_set_option(term_buf, "modifiable", false)

          vim.api.nvim_set_current_win(current_win)
        end
      end, 200)
    end,
  })

  -- Return cursor to the original buffer
  vim.cmd("wincmd p")

  -- Wait briefly before applying the cursor position to the terminal buffer
  vim.defer_fn(function()
    pcall(function()
      local original_id = vim.api.nvim_get_current_win()
      local original_pos = vim.api.nvim_win_get_cursor(original_id)
      vim.api.nvim_set_current_win(terminal_id)

      -- Get the number of lines in the terminal buffer
      local line_count = vim.api.nvim_buf_line_count(0)

      -- Ensure the cursor position is within the buffer range
      local cursor_pos = { math.min(original_pos[1], line_count), 0 }

      vim.api.nvim_win_set_cursor(terminal_id, cursor_pos)
      vim.api.nvim_set_current_win(original_id)
    end)
  end, 300)
end

local function close_preview_markdown()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- Check if this buffer is marked as a markdown preview buffer
    local success, is_preview = pcall(function()
      return vim.api.nvim_buf_get_var(buf, "is_markdown_preview")
    end)

    if success and is_preview then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

local function toggle_preview_markdown()
  vim.g.preview_markdown_enabled = not vim.g.preview_markdown_enabled
  if not vim.g.preview_markdown_enabled then
    close_preview_markdown()
  else
    preview_markdown()
  end
end

-- Function to sync cursor position from markdown to preview
local function sync_cursor_to_preview()
  if not vim.g.preview_markdown_enabled then
    return
  end

  if vim.bo.filetype ~= "markdown" then
    return
  end

  -- Find the preview buffer that corresponds to the current markdown file
  local current_win = vim.api.nvim_get_current_win()
  local current_pos = vim.api.nvim_win_get_cursor(current_win)
  local current_file = vim.api.nvim_buf_get_name(0)

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)

    -- Check if this buffer is marked as a markdown preview buffer
    local success, result = pcall(function()
      local is_md_preview = vim.api.nvim_buf_get_var(buf, "is_markdown_preview")
      local md_file_path = vim.api.nvim_buf_get_var(buf, "markdown_file_path")
      return { is_preview = is_md_preview, file_path = md_file_path }
    end)

    -- Only sync cursor if this preview corresponds to the current markdown file
    if success and result.is_preview and result.file_path == current_file then
      pcall(function()
        local line_count = vim.api.nvim_buf_line_count(buf)
        local cursor_pos = { math.min(current_pos[1], line_count), 0 }
        vim.api.nvim_win_set_cursor(win, cursor_pos)
      end)
      break
    end
  end
end

-- Function to sync cursor position from preview to markdown
local function sync_cursor_to_markdown()
  if not vim.g.preview_markdown_enabled then
    return
  end

  -- Check if current buffer is a markdown preview buffer
  local current_buf = vim.api.nvim_get_current_buf()
  local success, result = pcall(function()
    local is_md_preview = vim.api.nvim_buf_get_var(current_buf, "is_markdown_preview")
    local md_file_path = vim.api.nvim_buf_get_var(current_buf, "markdown_file_path")
    return { is_preview = is_md_preview, file_path = md_file_path }
  end)

  if not (success and result.is_preview) then
    return
  end

  -- Find the corresponding markdown file window
  local current_pos = vim.api.nvim_win_get_cursor(0)

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    local buftype = vim.api.nvim_buf_get_option(buf, "buftype")

    -- Check if this is the corresponding markdown file
    if buftype == "" and buf_name == result.file_path then
      pcall(function()
        local line_count = vim.api.nvim_buf_line_count(buf)
        local cursor_pos = { math.min(current_pos[1], line_count), current_pos[2] }
        vim.api.nvim_win_set_cursor(win, cursor_pos)
      end)
      break
    end
  end
end

-- Auto command to trigger when opening a Markdown file
api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.md",
  callback = preview_markdown,
})

-- Auto command to sync cursor position when moving in markdown files (markdown -> preview)
api.nvim_create_autocmd("CursorMoved", {
  pattern = "*.md",
  callback = sync_cursor_to_preview,
})

-- Auto command to sync cursor position when moving in preview buffers (preview -> markdown)
api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    -- Check if this is a preview buffer by trying to get the preview variables
    local current_buf = vim.api.nvim_get_current_buf()
    local success = pcall(function()
      return vim.api.nvim_buf_get_var(current_buf, "is_markdown_preview")
    end)

    if success then
      sync_cursor_to_markdown()
    end
  end,
})

-- Auto command to refresh preview when markdown file is saved
api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.md",
  callback = function()
    if vim.g.preview_markdown_enabled then
      preview_markdown()
    end
  end,
})

api.nvim_create_user_command("MarkdownOn", function()
  vim.g.preview_markdown_enabled = true
  preview_markdown()
end, {})
api.nvim_create_user_command("MarkdownOff", function()
  vim.g.preview_markdown_enabled = false
  close_preview_markdown()
end, {})
