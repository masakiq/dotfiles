-- iTerm2 prerequisites for this automation:
-- 1. Create a profile named "Web Browser".
--    `MarkdownPreviewITerm` splits the current session with:
--    `split vertically with profile "Web Browser"`.
-- 2. The "Web Browser" profile must open the browser pane/window that accepts
--    `Cmd-L`, `Cmd-V`, and `Enter` to navigate to the clipboard URL.
-- 3. macOS Accessibility / Automation permissions must allow the UI scripting
--    used below, otherwise the simulated keystrokes against iTerm2 will fail.

require("markdown_preview").setup({
  port = 8421,
  open_browser = false,
  debounce_ms = 300,
  auto_refresh = true,
  notify_on_refresh = false,
  mermaid_renderer = "js",
  scroll_sync = true,
})

local preview_iterm_session_id = nil

local function is_markdown_file_buffer(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  if vim.bo[bufnr].buftype ~= "" then
    return false
  end

  return vim.api.nvim_buf_get_name(bufnr):match("%.md$") ~= nil
end

local function has_markdown_file_tabs()
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    if vim.api.nvim_tabpage_is_valid(tabpage) then
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
        if is_markdown_file_buffer(vim.api.nvim_win_get_buf(win)) then
          return true
        end
      end
    end
  end

  return false
end

local function preview_iterm_session_exists()
  if not preview_iterm_session_id or preview_iterm_session_id == "" then
    return false
  end

  local script = [[
on run argv
  set targetSessionId to item 1 of argv

  tell application "iTerm2"
    repeat with aWindow in windows
      repeat with aTab in tabs of aWindow
        repeat with aSession in sessions of aTab
          if (id of aSession as text) is targetSessionId then
            return "found"
          end if
        end repeat
      end repeat
    end repeat
  end tell

  return "missing"
end run
]]

  local result = vim.fn.systemlist({ "osascript", "-e", script, preview_iterm_session_id })
  if vim.v.shell_error ~= 0 or result[1] ~= "found" then
    preview_iterm_session_id = nil
    return false
  end

  return true
end

local function open_markdown_preview_in_iterm()
  if vim.bo.filetype ~= "markdown" then
    vim.notify("Markdown file is required", vim.log.levels.WARN)
    return
  end

  local port = require("markdown_preview").config.port or 8421
  local url = ("http://localhost:%d"):format(port)
  local script = [[
on run argv
  set previewUrl to item 1 of argv
  set previousClipboard to the clipboard
  set the clipboard to previewUrl

  tell application "iTerm2"
    activate
    if (count of windows) = 0 then
      create window with default profile
      delay 0.1
    end if

    set baseSession to current session of current window
    tell baseSession
      set newSession to (split vertically with profile "Web Browser")
    end tell

    delay 0.1
    tell newSession to select
  end tell

  delay 0.1

  tell application "System Events"
    tell process "iTerm2"
      set frontmost to true
      keystroke "l" using {command down}
      delay 0.1
      keystroke "v" using {command down}
      delay 0.2
      key code 36
    end tell
  end tell

  delay 0.1

  tell application "iTerm2"
    tell baseSession to select
  end tell

  delay 0.1

  if (the clipboard as text) is previewUrl then
    set the clipboard to previousClipboard
  end if

  return (id of newSession) as text
end run
]]

  vim.cmd("MarkdownPreview")

  if preview_iterm_session_exists() then
    return
  end

  local result = vim.fn.systemlist({ "osascript", "-e", script, url })
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to run iTerm2 preview automation", vim.log.levels.ERROR)
    return
  end

  preview_iterm_session_id = result[1] or nil
end

local function stop_markdown_preview_in_iterm()
  pcall(function()
    vim.cmd("MarkdownPreviewStop")
  end)

  if not preview_iterm_session_id or preview_iterm_session_id == "" then
    return
  end

  local script = [[
on run argv
  set targetSessionId to item 1 of argv

  tell application "iTerm2"
    repeat with aWindow in windows
      repeat with aTab in tabs of aWindow
        repeat with aSession in sessions of aTab
          if (id of aSession as text) is targetSessionId then
            tell aSession to select
            delay 0.1
            tell application "System Events"
              tell process "iTerm2"
                set frontmost to true
                keystroke "w" using {command down}
              end tell
            end tell
            return "closed"
          end if
        end repeat
      end repeat
    end repeat
  end tell

  return "missing"
end run
]]

  local result = vim.fn.systemlist({ "osascript", "-e", script, preview_iterm_session_id })
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to close iTerm2 preview pane", vim.log.levels.ERROR)
    return
  end

  if result[1] == "closed" or result[1] == "missing" then
    preview_iterm_session_id = nil
  end
end

local markdown_preview_auto_group = vim.api.nvim_create_augroup("MarkdownPreviewAutoStart", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  group = markdown_preview_auto_group,
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "markdown" then
      return
    end

    if vim.bo[args.buf].buftype ~= "" or vim.api.nvim_buf_get_name(args.buf) == "" then
      return
    end

    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(args.buf) or vim.api.nvim_get_current_buf() ~= args.buf then
        return
      end

      if vim.bo[args.buf].filetype ~= "markdown" or vim.bo[args.buf].buftype ~= "" then
        return
      end

      vim.api.nvim_buf_call(args.buf, function()
        open_markdown_preview_in_iterm()
      end)
    end)
  end,
})

vim.api.nvim_create_autocmd("TabClosed", {
  group = markdown_preview_auto_group,
  callback = function()
    vim.schedule(function()
      if has_markdown_file_tabs() then
        return
      end

      stop_markdown_preview_in_iterm()
    end)
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = markdown_preview_auto_group,
  callback = function()
    stop_markdown_preview_in_iterm()
  end,
})

vim.api.nvim_create_user_command("MarkdownPreviewITerm", open_markdown_preview_in_iterm, {})
vim.api.nvim_create_user_command("MarkdownPreviewITermStop", stop_markdown_preview_in_iterm, {})
