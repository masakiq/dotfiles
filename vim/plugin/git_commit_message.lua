-- Commit message generator for gitcommit buffers.
-- Usage:
-- - Open `.git/COMMIT_EDITMSG` to open a preview buffer on the right and start async generation.
-- - `:CommitMessageProvider` shows the current provider.
-- - `:CommitMessageProvider claude` switches to Claude.
-- - `:CommitMessageProvider codex` switches to Codex.
-- - `:CommitMessageGenerate` regenerates the suggestion with the current provider.
-- - Press `<CR>` in the preview buffer, or run `:CommitMessageApply`, to apply the suggestion.
-- - Set `vim.g.git_commit_message_provider = "codex"` before this file loads to change the default.

local group = vim.api.nvim_create_augroup("CommitMessageGenerator", { clear = true })
local provider_var = "git_commit_message_provider"
local default_provider = "codex"

local providers = {
  claude = {
    display_name = "Claude",
    executable = "claude",
    failure_label = "`claude -p`",
    build_command = function()
      return {
        "claude",
        "-p",
        "--output-format",
        "text",
        "--no-session-persistence",
        "--tools",
        "",
      }
    end,
  },
  codex = {
    display_name = "Codex",
    executable = "codex",
    failure_label = "`codex exec`",
    build_command = function()
      return {
        "codex",
        -- Global Codex CLI options must precede `exec`.
        "-c",
        [[model_reasoning_effort="low"]],
        "--ask-for-approval",
        "never",
        "exec",
        "--sandbox",
        "read-only",
        "--color",
        "never",
        "--ephemeral",
        "-",
      }
    end,
  },
}

local function notify(message, level)
  vim.schedule(function()
    vim.notify(message, level or vim.log.levels.INFO)
  end)
end

local function provider_names()
  return vim.tbl_keys(providers)
end

local function normalize_provider_name(provider)
  local normalized = vim.trim((provider or ""):lower())
  if providers[normalized] then
    return normalized
  end

  return nil
end

local function set_provider(provider, opts)
  local normalized = normalize_provider_name(provider)

  if not normalized then
    notify("Unknown commit message provider: " .. tostring(provider), vim.log.levels.WARN)
    return false
  end

  vim.g[provider_var] = normalized

  if not (opts and opts.silent) then
    notify("Commit message provider: " .. normalized)
  end

  return true
end

local function get_provider()
  local provider = normalize_provider_name(vim.g[provider_var]) or default_provider
  if vim.g[provider_var] ~= provider then
    vim.g[provider_var] = provider
  end

  return provider, providers[provider]
end

set_provider(vim.g[provider_var] or default_provider, { silent = true })

local function configure_preview_buffer(preview_bufnr, source_bufnr)
  vim.b[preview_bufnr].commit_message_target_bufnr = source_bufnr

  vim.bo[preview_bufnr].buftype = "nofile"
  vim.bo[preview_bufnr].bufhidden = "wipe"
  vim.bo[preview_bufnr].buflisted = false
  vim.bo[preview_bufnr].swapfile = false
  vim.bo[preview_bufnr].filetype = "gitcommit"
  vim.bo[preview_bufnr].modifiable = true

  vim.keymap.set("n", "q", "<cmd>close<cr>", {
    buffer = preview_bufnr,
    silent = true,
    desc = "Close commit message preview",
  })
  vim.keymap.set("n", "<cr>", "<cmd>CommitMessageApply<cr>", {
    buffer = preview_bufnr,
    silent = true,
    desc = "Apply commit message preview",
  })
end

local function configure_preview_window(preview_winid)
  vim.wo[preview_winid].number = false
  vim.wo[preview_winid].relativenumber = false
  vim.wo[preview_winid].signcolumn = "no"
  vim.wo[preview_winid].winfixwidth = true

  local width = math.max(40, math.floor(vim.o.columns * 0.35))
  pcall(vim.api.nvim_win_set_width, preview_winid, width)
end

local function ensure_preview_window(source_bufnr)
  local current_win = vim.api.nvim_get_current_win()
  local preview_bufnr = vim.b[source_bufnr].commit_message_preview_bufnr

  if not preview_bufnr or not vim.api.nvim_buf_is_valid(preview_bufnr) then
    preview_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(preview_bufnr, "commit-message://" .. source_bufnr)
    configure_preview_buffer(preview_bufnr, source_bufnr)
    vim.b[source_bufnr].commit_message_preview_bufnr = preview_bufnr
  end

  local preview_winid = vim.fn.bufwinid(preview_bufnr)
  if preview_winid == -1 then
    vim.cmd("botright vsplit")
    preview_winid = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(preview_winid, preview_bufnr)
    configure_preview_window(preview_winid)
  else
    preview_winid = tonumber(preview_winid)
  end

  if vim.api.nvim_win_is_valid(current_win) then
    vim.api.nvim_set_current_win(current_win)
  end

  return preview_bufnr, preview_winid
end

local function build_preview_lines(provider_name, body_lines)
  local lines = vim.deepcopy(body_lines)

  table.insert(lines, "")
  table.insert(lines, "# Provider: " .. provider_name)
  table.insert(lines, "# Edit the first line if needed, then press <CR> or run :CommitMessageApply")

  return lines
end

local function set_preview_lines(source_bufnr, provider_name, body_lines)
  local preview_bufnr = ensure_preview_window(source_bufnr)

  vim.api.nvim_buf_set_lines(preview_bufnr, 0, -1, false, build_preview_lines(provider_name, body_lines))
  vim.bo[preview_bufnr].modified = false

  return preview_bufnr
end

local function preview_status(source_bufnr, provider_name, status)
  set_preview_lines(source_bufnr, provider_name, { "# " .. status })
end

local function has_staged_diff(diff_text)
  return vim.trim(diff_text) ~= ""
end

local function normalize_commit_message(output)
  for _, raw_line in ipairs(vim.split(vim.trim(output), "\n", { plain = true })) do
    local line = vim.trim(raw_line)

    if line == "" then
    elseif line:match("^```") then
    else
      line = line:gsub("^['\"]", ""):gsub("['\"]$", "")
      line = line:gsub("^%s*[%-%*]%s*", "")
      line = vim.trim(line)
      if line ~= "" then
        return line
      end
    end
  end

  return nil
end

local function insert_commit_message(bufnr, message)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local comment_start = #lines + 1
  local subject_idx = nil

  for idx, line in ipairs(lines) do
    if line:match("^#") or line:match("^diff %-%-git ") then
      comment_start = idx
      break
    end
  end

  for idx = 1, comment_start - 1 do
    if lines[idx]:match("^%s*$") then
    else
      subject_idx = idx
      break
    end
  end

  if not subject_idx then
    local replace_until = 0

    for idx = 1, comment_start - 1 do
      if lines[idx]:match("^%s*$") then
        replace_until = idx
      else
        break
      end
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, replace_until, false, { message, "" })
  else
    local replacement = { message }
    local next_line = lines[subject_idx + 1]

    if next_line and not next_line:match("^%s*$") then
      table.insert(replacement, "")
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, subject_idx, false, replacement)
  end

  if vim.api.nvim_get_current_buf() == bufnr then
    vim.api.nvim_win_set_cursor(0, { 1, #message })
  end
end

local function get_preview_message(preview_bufnr)
  if not preview_bufnr or not vim.api.nvim_buf_is_valid(preview_bufnr) then
    return nil
  end

  for _, raw_line in ipairs(vim.api.nvim_buf_get_lines(preview_bufnr, 0, -1, false)) do
    local line = vim.trim(raw_line)
    if line == "" then
    elseif line:match("^#") then
    else
      return line
    end
  end

  return nil
end

local function update_preview_buffer(source_bufnr, provider_name, message)
  set_preview_lines(source_bufnr, provider_name, { message })
end

local function apply_preview_to_commit_buffer(bufnr)
  local source_bufnr = bufnr
  local preview_bufnr = nil

  if vim.b[bufnr].commit_message_target_bufnr then
    source_bufnr = vim.b[bufnr].commit_message_target_bufnr
    preview_bufnr = bufnr
  else
    preview_bufnr = vim.b[bufnr].commit_message_preview_bufnr
  end

  if
    not source_bufnr
    or not vim.api.nvim_buf_is_valid(source_bufnr)
    or vim.bo[source_bufnr].filetype ~= "gitcommit"
  then
    notify("No target gitcommit buffer available", vim.log.levels.WARN)
    return
  end

  local message = get_preview_message(preview_bufnr)
  if not message then
    notify("No previewed commit message available", vim.log.levels.WARN)
    return
  end

  insert_commit_message(source_bufnr, message)
  notify("Applied commit message suggestion")
end

local function build_prompt(diff_text)
  return table.concat({
    "Write a single git commit subject for the staged diff below.",
    "Requirements:",
    "- Follow Conventional Commits.",
    "- Keep the subject within 80 characters.",
    "- Use imperative mood.",
    "- Return only the subject line.",
    "- Do not use code fences, quotes, or explanations.",
    "",
    "Staged diff:",
    diff_text,
  }, "\n")
end

local function generate_commit_message(bufnr)
  bufnr = vim.b[bufnr].commit_message_target_bufnr or bufnr

  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "gitcommit" then
    return
  end

  if vim.b[bufnr].commit_message_generation_inflight then
    return
  end

  local _, provider = get_provider()
  preview_status(bufnr, provider.display_name, "Generating commit message...")

  if vim.fn.executable(provider.executable) ~= 1 then
    preview_status(bufnr, provider.display_name, "`" .. provider.executable .. "` command not found")
    notify("`" .. provider.executable .. "` command not found; skipping commit message generation", vim.log.levels.WARN)
    return
  end

  local cwd = vim.fn.getcwd()
  vim.b[bufnr].commit_message_generation_inflight = true

  vim.system(
    { "git", "diff", "--staged", "--no-ext-diff" },
    { cwd = cwd, text = true },
    vim.schedule_wrap(function(diff_result)
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      if diff_result.code ~= 0 then
        vim.b[bufnr].commit_message_generation_inflight = false
        preview_status(bufnr, provider.display_name, "Failed to read staged diff")
        notify("Failed to read staged diff: " .. vim.trim(diff_result.stderr or ""), vim.log.levels.WARN)
        return
      end

      local diff_text = diff_result.stdout or ""
      if not has_staged_diff(diff_text) then
        vim.b[bufnr].commit_message_generation_inflight = false
        preview_status(bufnr, provider.display_name, "No staged changes to summarize")
        return
      end

      local prompt = build_prompt(diff_text)

      vim.system(
        provider.build_command(),
        { cwd = cwd, text = true, stdin = prompt },
        vim.schedule_wrap(function(provider_result)
          vim.b[bufnr].commit_message_generation_inflight = false

          if not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end

          if provider_result.code ~= 0 then
            preview_status(bufnr, provider.display_name, provider.failure_label .. " failed")
            notify(provider.failure_label .. " failed: " .. vim.trim(provider_result.stderr or ""), vim.log.levels.WARN)
            return
          end

          local message = normalize_commit_message(provider_result.stdout or "")
          if not message then
            preview_status(bufnr, provider.display_name, "No usable commit message returned")
            notify(provider.display_name .. " did not return a usable commit message", vim.log.levels.WARN)
            return
          end

          update_preview_buffer(bufnr, provider.display_name, message)
        end)
      )
    end)
  )
end

vim.api.nvim_create_user_command("CommitMessageGenerate", function()
  generate_commit_message(vim.api.nvim_get_current_buf())
end, { desc = "Generate a commit message from the staged diff with the configured AI CLI" })

vim.api.nvim_create_user_command("ClaudeCommitMessage", function()
  generate_commit_message(vim.api.nvim_get_current_buf())
end, { desc = "Alias for CommitMessageGenerate" })

vim.api.nvim_create_user_command("CommitMessageApply", function()
  apply_preview_to_commit_buffer(vim.api.nvim_get_current_buf())
end, { desc = "Apply the previewed commit message to the gitcommit buffer" })

vim.api.nvim_create_user_command("CommitMessageProvider", function(opts)
  if opts.args == "" then
    local provider = get_provider()
    notify("Commit message provider: " .. provider)
    return
  end

  set_provider(opts.args)
end, {
  nargs = "?",
  complete = function()
    return provider_names()
  end,
  desc = "Show or change the AI provider for commit message generation",
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "gitcommit",
  callback = function(args)
    if vim.b[args.buf].commit_message_target_bufnr then
      return
    end

    if vim.b[args.buf].commit_message_generation_requested then
      return
    end

    vim.b[args.buf].commit_message_generation_requested = true
    local _, provider = get_provider()
    preview_status(args.buf, provider.display_name, "Generating commit message...")
    vim.defer_fn(function()
      generate_commit_message(args.buf)
    end, 100)
  end,
})
