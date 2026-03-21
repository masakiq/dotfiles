local M = {}

local function pascal_to_snake(s)
  s = s:gsub("(%u)", function(c)
    return "_" .. c:lower()
  end)

  return s:gsub("^_", "")
end

local function snake_to_pascal(s)
  s = s:gsub("_(%l)", function(c)
    return c:upper()
  end)

  return s:gsub("^%l", string.upper)
end

local function replace_selection(context, transform)
  if context.start_line ~= context.end_line then
    vim.notify("Multiple line selection is not supported.", vim.log.levels.WARN)
    return
  end

  local converted = transform(context.text)
  vim.api.nvim_buf_set_text(
    context.bufnr,
    context.start_line - 1,
    context.start_col - 1,
    context.end_line - 1,
    context.end_col,
    { converted }
  )
end

local function snake_case(context)
  replace_selection(context, pascal_to_snake)
end

local function pascal_case(context)
  replace_selection(context, snake_to_pascal)
end

local function remove_under_bar(context)
  replace_selection(context, function(text)
    return text:gsub("_", " ")
  end)
end

local function add_under_bar(context)
  replace_selection(context, function(text)
    return text:gsub(" ", "_")
  end)
end

local function copy_current_path_with_line_number(context)
  local path = vim.fn.expand("%")
  local lines = {}

  for line = context.start_line, context.end_line do
    table.insert(lines, tostring(line))
  end

  local line_path = path .. ":" .. table.concat(lines, ":")
  vim.fn.setreg("+", line_path)
  print("copied current path: " .. line_path)
end

M.entries = {
  { label = "SnakeCase", callback = snake_case },
  { label = "PascalCase", callback = pascal_case },
  { label = "RemoveUnderBar", callback = remove_under_bar },
  { label = "AddUnderBar", callback = add_under_bar },
  { label = "CopyCurrentPathWithLineNumber", callback = copy_current_path_with_line_number },
  { label = "OpenGitHubFileVisual", command = "OpenGitHubFileVisual" },
}

return M
