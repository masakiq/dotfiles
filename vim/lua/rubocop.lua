local M = {}

local function trim(value)
  return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function extract_cop_from_message(message)
  if type(message) ~= "string" then
    return nil
  end

  return message:match("%[([^%[%]]+/[^%[%]]+)%]%s*$")
end

local function extract_cop_name(diagnostic)
  if type(diagnostic.code) == "string" and diagnostic.code:find("/", 1, true) then
    return diagnostic.code
  end

  return extract_cop_from_message(diagnostic.message)
end

local function is_rubocop_diagnostic(diagnostic)
  if type(diagnostic.source) == "string" and diagnostic.source:lower():find("rubocop", 1, true) then
    return true
  end

  return extract_cop_name(diagnostic) ~= nil
end

local function normalize_message(diagnostic, cop)
  local message = diagnostic.message or ""
  message = message:gsub("%s*%[[^%[%]]+/[^%[%]]+%]%s*$", "")
  if cop and message:sub(1, #cop + 2) == cop .. ": " then
    message = message:sub(#cop + 3)
  end
  return trim(message)
end

local function collect_current_line_offenses(bufnr, line)
  local offenses = {}
  local seen = {}

  for _, diagnostic in ipairs(vim.diagnostic.get(bufnr, { lnum = line })) do
    if is_rubocop_diagnostic(diagnostic) then
      local cop = extract_cop_name(diagnostic)
      if cop and not seen[cop] then
        seen[cop] = true
        table.insert(offenses, {
          cop = cop,
          message = normalize_message(diagnostic, cop),
          source = diagnostic.source or "",
        })
      end
    end
  end

  table.sort(offenses, function(a, b)
    return a.cop < b.cop
  end)

  return offenses
end

local function format_offense_item(item)
  if item.message ~= "" then
    return item.cop .. ": " .. item.message
  end

  return item.cop
end

local function parse_disable_cops(value)
  local cops = {}
  for cop in value:gmatch("[^,]+") do
    local trimmed = trim(cop)
    if trimmed ~= "" then
      table.insert(cops, trimmed)
    end
  end
  return cops
end

local function merge_cops(existing_cops, new_cops)
  local merged = {}
  local seen = {}

  for _, cop in ipairs(existing_cops) do
    if not seen[cop] then
      seen[cop] = true
      table.insert(merged, cop)
    end
  end

  for _, cop in ipairs(new_cops) do
    if not seen[cop] then
      seen[cop] = true
      table.insert(merged, cop)
    end
  end

  return merged
end

local function append_disable_comment(line, cops)
  if line:match("^%s*$") then
    return "# rubocop:disable " .. table.concat(cops, ", ")
  end

  local before, existing = line:match("^(.-)#%s*rubocop:disable%s+(.+)$")
  if existing then
    local merged = merge_cops(parse_disable_cops(existing), cops)
    return before .. "# rubocop:disable " .. table.concat(merged, ", ")
  end

  return line .. " # rubocop:disable " .. table.concat(cops, ", ")
end

function M.disable_current_line_cops()
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local offenses = collect_current_line_offenses(bufnr, line)

  if vim.tbl_isempty(offenses) then
    vim.notify("No RuboCop diagnostics found on the current line.", vim.log.levels.WARN)
    return
  end

  vim.ui.select(offenses, {
    prompt = "Select RuboCop offense to disable",
    format_item = format_offense_item,
  }, function(choice)
    if not choice then
      return
    end

    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    local current_line = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] or ""
    local updated_line = append_disable_comment(current_line, { choice.cop })

    if updated_line == current_line then
      vim.notify("Current line already disables " .. choice.cop .. ".", vim.log.levels.INFO)
      return
    end

    vim.api.nvim_buf_set_lines(bufnr, line, line + 1, false, { updated_line })
    vim.notify("Added rubocop:disable for " .. choice.cop, vim.log.levels.INFO)
  end)
end

return M
