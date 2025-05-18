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

local function selection_to_snake()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local sr, sc = start_pos[2], start_pos[3]
  local er, ec = end_pos[2], end_pos[3]

  if sr ~= er then
    vim.notify("Multiple line selection is not supported.", vim.log.levels.WARN)
    return
  end

  local line = vim.api.nvim_buf_get_lines(0, sr - 1, sr, false)[1]
  local text = line:sub(sc, ec)
  local converted = pascal_to_snake(text)

  vim.api.nvim_buf_set_text(0, sr - 1, sc - 1, er - 1, ec, { converted })
end

local function selection_to_pascal()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local sr, sc = start_pos[2], start_pos[3]
  local er, ec = end_pos[2], end_pos[3]

  if sr ~= er then
    vim.notify("Multiple line selection is not supported.", vim.log.levels.WARN)
    return
  end

  local line = vim.api.nvim_buf_get_lines(0, sr - 1, sr, false)[1]
  local text = line:sub(sc, ec)
  local converted = snake_to_pascal(text)

  vim.api.nvim_buf_set_text(0, sr - 1, sc - 1, er - 1, ec, { converted })
end

local function selection_underscore_to_space()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local sr, sc = start_pos[2], start_pos[3]
  local er, ec = end_pos[2], end_pos[3]

  if sr ~= er then
    vim.notify("Multiple line selection is not supported.", vim.log.levels.WARN)
    return
  end

  local line = vim.api.nvim_buf_get_lines(0, sr - 1, sr, false)[1]
  local text = line:sub(sc, ec)
  local converted = text:gsub("_", " ")

  vim.api.nvim_buf_set_text(0, sr - 1, sc - 1, er - 1, ec, { converted })
end

local function selection_space_to_underscore()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local sr, sc = start_pos[2], start_pos[3]
  local er, ec = end_pos[2], end_pos[3]

  if sr ~= er then
    vim.notify("Multiple line selection is not supported.", vim.log.levels.WARN)
    return
  end

  local line = vim.api.nvim_buf_get_lines(0, sr - 1, sr, false)[1]
  local text = line:sub(sc, ec)
  local converted = text:gsub(" ", "_")

  vim.api.nvim_buf_set_text(0, sr - 1, sc - 1, er - 1, ec, { converted })
end

vim.api.nvim_create_user_command("SnakeCase", function(opts)
  selection_to_snake()
end, { range = true })

vim.api.nvim_create_user_command("PascalCase", function(opts)
  selection_to_pascal()
end, { range = true })

vim.api.nvim_create_user_command("RemoveUnderBar", function()
  selection_underscore_to_space()
end, { range = true })

vim.api.nvim_create_user_command("AddUnderBar", function()
  selection_space_to_underscore()
end, { range = true })

local function strip_ansi_all()
  local esc = string.char(27)
  local ansi_pattern = esc .. "%[[0-9;]*[%a]"

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i, line in ipairs(lines) do
    lines[i] = line:gsub(ansi_pattern, "")
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

vim.api.nvim_create_user_command("StripAnsi", function()
  strip_ansi_all()
end, { range = true })
