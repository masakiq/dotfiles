-- Ghostty: uses `terminal-browser open <url> --split right` (native Ghostty split even inside tmux).
-- The pane is closed via Ghostty AppleScript (`close terminal id`).
--
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
local preview_ghostty_browser_key = nil

local function is_ghostty()
  if vim.env.TERM_PROGRAM == "ghostty" or vim.env.TERM == "xterm-ghostty" then
    return true
  end

  -- Inside tmux the environment can be stale (inherited from the terminal that
  -- started the tmux server), so ask tmux for the attached client's TERM.
  if (vim.env.TMUX or "") ~= "" then
    local termname = vim.fn.system({ "tmux", "display-message", "-p", "#{client_termname}" })
    if vim.v.shell_error == 0 and termname:match("ghostty") then
      return true
    end
  end

  return false
end

-- terminal-browser picks tmux over Ghostty when $TMUX is set. Hide tmux and
-- present the environment as plain Ghostty so it splits a native Ghostty pane.
local function terminal_browser_cmd(args)
  local cmd = {
    "env",
    "-u",
    "TMUX",
    "-u",
    "TMUX_PANE",
    "TERM=xterm-ghostty",
    "TERM_PROGRAM=ghostty",
    "TERM_PROGRAM_VERSION=1.3.0",
    "terminal-browser",
  }
  vim.list_extend(cmd, args)
  return cmd
end

local function ghostty_browsers()
  local output = vim.fn.system(terminal_browser_cmd({ "ls", "--json" }))
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local ok, decoded = pcall(vim.json.decode, output)
  if ok and type(decoded) == "table" and type(decoded.browsers) == "table" then
    return decoded.browsers
  end

  return {}
end

local function ghostty_terminal_ids()
  local output = vim.fn.system({
    "osascript",
    "-e",
    'tell application "Ghostty" to get id of every terminal',
  })
  local ids = {}
  if vim.v.shell_error ~= 0 then
    return nil
  end

  for id in output:gmatch("[%w%-]+") do
    ids[id] = true
  end
  return ids
end

-- A browser entry can outlive its pane (the client processes linger after the
-- pane is closed), so only count browsers whose pane still exists in Ghostty.
local function ghostty_browser_exists()
  local browsers = ghostty_browsers()
  if #browsers == 0 then
    return false
  end

  local ids = ghostty_terminal_ids()
  if not ids then
    return true
  end

  for _, browser in ipairs(browsers) do
    local pane_id = type(browser.pane) == "table" and browser.pane.pane or nil
    if pane_id and ids[pane_id] then
      return true
    end
  end

  return false
end

local function terminate_processes_on_tty(tty)
  local pids = vim.fn.systemlist({ "ps", "-t", tty, "-o", "pid=" })
  if vim.v.shell_error ~= 0 then
    return
  end

  for _, pid in ipairs(pids) do
    local n = tonumber(vim.trim(pid))
    if n and n > 1 then
      pcall(vim.uv.kill, n, "sigterm")
    end
  end
end

-- terminal-browser has no "close" command. Close the pane through Ghostty's
-- AppleScript API (Ghostty 1.3+) so no "Process exited" prompt is left behind.
-- If that fails, fall back to terminating the processes on the pane's tty.
local function close_markdown_preview_in_ghostty()
  local key = preview_ghostty_browser_key
  preview_ghostty_browser_key = nil
  if not key then
    return
  end

  for _, browser in ipairs(ghostty_browsers()) do
    if browser.key == key then
      local pane_id = type(browser.pane) == "table" and browser.pane.pane or nil

      if type(pane_id) == "string" and pane_id:match("^[%w%-]+$") then
        vim.fn.system({
          "osascript",
          "-e",
          'tell application "Ghostty" to close terminal id "' .. pane_id .. '"',
        })
      end

      -- Closing the pane leaves its client processes running; clean them up so
      -- they do not linger as a stale terminal-browser entry.
      local tty = type(browser.tty) == "string" and browser.tty:match("^/dev/(ttys%d+)$")
      if tty then
        terminate_processes_on_tty(tty)
      end
    end
  end
end

local function ghostty_focused_terminal_id()
  local id = vim.fn.system({
    "osascript",
    "-e",
    'tell application "Ghostty" to get id of focused terminal of selected tab of front window',
  })
  id = vim.trim(id)
  if vim.v.shell_error == 0 and id:match("^[%w%-]+$") then
    return id
  end
  return nil
end

local function focus_ghostty_terminal(id)
  if not id then
    return
  end
  vim.fn.system({
    "osascript",
    "-e",
    'tell application "Ghostty" to focus terminal id "' .. id .. '"',
  })
end

local function open_markdown_preview_in_ghostty(url)
  if vim.fn.executable("terminal-browser") ~= 1 then
    vim.notify("terminal-browser is not installed", vim.log.levels.ERROR)
    return
  end

  if ghostty_browser_exists() then
    return
  end

  local editor_terminal_id = ghostty_focused_terminal_id()
  local result = vim.fn.system(terminal_browser_cmd({ "open", url, "--split", "right" }))
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to open terminal-browser preview: " .. result, vim.log.levels.ERROR)
    return
  end

  -- The new split takes focus; return it to the editor pane.
  focus_ghostty_terminal(editor_terminal_id)

  preview_ghostty_browser_key = result:match("opened%s+(%S+)")
end

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

  local markdown_preview = require("markdown_preview")
  vim.cmd("MarkdownPreview")
  local url = markdown_preview.url()

  if not url or url == "" then
    vim.notify("Markdown Preview URL could not be resolved", vim.log.levels.ERROR)
    return
  end

  if is_ghostty() then
    open_markdown_preview_in_ghostty(url)
    return
  end

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

  if is_ghostty() then
    close_markdown_preview_in_ghostty()
    return
  end

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
