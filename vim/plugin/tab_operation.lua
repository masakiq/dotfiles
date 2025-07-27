-- Tab operation functions
local function close_tabs_right(bang)
  local cur = vim.fn.tabpagenr()
  while cur < vim.fn.tabpagenr("$") do
    vim.cmd("tabclose" .. bang .. " " .. (cur + 1))
  end
end

local function close_tabs_left(bang)
  while vim.fn.tabpagenr() > 1 do
    vim.cmd("tabclose" .. bang .. " 1")
  end
end

local function close_tabs(bang)
  close_tabs_right(bang)
  close_tabs_left(bang)
end

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

local function separate_tab()
  vim.cmd("wincmd l")
  local file = vim.fn.expand("%")
  vim.cmd("close")
  vim.cmd("tab drop " .. file)
  vim.cmd("normal! gT")
end

local function copy_all_tab_path()
  local files = { vim.fn.expand("%") }
  local max = 20
  local index = 0

  while index < max do
    vim.cmd("sleep 50ms")
    index = index + 1
    vim.cmd("silent! normal! gt")
    local file = vim.fn.expand("%")
    if file == files[1] then
      break
    end
    table.insert(files, file)
  end

  vim.fn.setreg("+", table.concat(files, "\n"))
end

local function open_files_from_clipboard()
  local clipboard_contents = vim.fn.getreg("+")
  local files = vim.split(clipboard_contents, "\n")

  for _, file in ipairs(files) do
    vim.cmd("tab drop " .. file)
  end
end

local function copy_all_tab_absolute_path()
  local files = { vim.fn.expand("%:p") }
  local max = 20
  local index = 0

  while index < max do
    vim.cmd("sleep 50ms")
    index = index + 1
    vim.cmd("silent! normal! gt")
    local file = vim.fn.expand("%:p")
    if file == files[1] then
      break
    end
    table.insert(files, file)
  end

  vim.fn.setreg("+", table.concat(files, "\n"))
end

vim.api.nvim_create_user_command("CloseTabsRight", function(opts)
  local bang = opts.bang and "!" or ""
  close_tabs_right(bang)
end, { bang = true })

vim.api.nvim_create_user_command("CloseTabsLeft", function(opts)
  local bang = opts.bang and "!" or ""
  close_tabs_left(bang)
end, { bang = true })

vim.api.nvim_create_user_command("CloseTabs", function(opts)
  local bang = opts.bang and "!" or ""
  close_tabs(bang)
end, { bang = true })

vim.api.nvim_create_user_command("MergeTab", merge_tab, {})
vim.api.nvim_create_user_command("SeparateTab", separate_tab, {})
vim.api.nvim_create_user_command("CopyAllTabPath", copy_all_tab_path, {})
vim.api.nvim_create_user_command("OpenFilesFromClipboard", open_files_from_clipboard, {})
vim.api.nvim_create_user_command("CopyAllTabAbsolutePath", copy_all_tab_absolute_path, {})

vim.keymap.set("n", "<leader>m", merge_tab, { desc = "Merge Tab" })
vim.keymap.set("n", "<leader>s", separate_tab, { desc = "Separate Tab" })
