-- Configuration for zbirenbaum/copilot.lua
-- This file contains the setup for the copilot plugin

-- Check if the plugin is installed
local ok, copilot = pcall(require, "copilot")
if not ok then
  return
end

local function read_file(path)
  local file = io.open(path, "rb")
  if not file then
    return nil
  end

  local contents = file:read("*a")
  file:close()
  return contents
end

local function read_trust_database()
  local trust = {}
  local file = io.open(vim.fn.stdpath("state") .. "/trust", "r")

  if not file then
    return trust
  end

  for line in file:lines() do
    local hash, trusted_path = string.match(line, "^(%S+) (.+)$")
    if hash and trusted_path then
      trust[trusted_path] = hash
    end
  end

  file:close()
  return trust
end

local function copilot_auth_path()
  local config_home = vim.env.XDG_CONFIG_HOME

  if config_home and config_home ~= "" then
    return config_home .. "/github-copilot/apps.json"
  end

  return vim.fn.expand("~/.config/github-copilot/apps.json")
end

local function copilot_auth_trust_state(path)
  local realpath = vim.uv.fs_realpath(vim.fs.normalize(path))
  if not realpath then
    return "missing"
  end

  local entry = read_trust_database()[realpath]
  if entry == "!" then
    return "denied"
  end

  local contents = read_file(realpath)
  if not contents then
    return "missing"
  end

  if entry == vim.fn.sha256(contents) then
    return "allowed"
  end

  return "unknown"
end

local function ensure_copilot_auth_trusted()
  if not vim.secure or type(vim.secure.trust) ~= "function" then
    return true
  end

  if os.getenv("GITHUB_COPILOT_TOKEN") or os.getenv("GH_COPILOT_TOKEN") then
    return true
  end

  local path = copilot_auth_path()
  if vim.fn.filereadable(path) == 0 then
    return true
  end

  local trust_state = copilot_auth_trust_state(path)
  if trust_state == "allowed" then
    return true
  end

  if trust_state == "denied" then
    vim.notify(string.format("[Copilot.lua] Skipping setup because %s is denied in :trust", path), vim.log.levels.WARN)
    return false
  end

  -- Neovim 0.11 gates this auth cache behind the trust DB, so allow this one file up front.
  local bufnr = vim.fn.bufadd(path)
  local was_loaded = vim.api.nvim_buf_is_loaded(bufnr)

  if not was_loaded then
    local loaded_ok, load_err = pcall(vim.fn.bufload, bufnr)
    if not loaded_ok then
      vim.notify(string.format("[Copilot.lua] Failed to load %s for :trust: %s", path, load_err), vim.log.levels.WARN)
      return false
    end
  end

  local trust_ok, trust_err = pcall(vim.secure.trust, {
    action = "allow",
    bufnr = bufnr,
  })

  if not was_loaded and vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end

  if not trust_ok then
    vim.notify(string.format("[Copilot.lua] Failed to trust %s: %s", path, trust_err), vim.log.levels.WARN)
    return false
  end

  return trust_ok
end

local function setup_copilot()
  if not ensure_copilot_auth_trusted() then
    return
  end

  -- Delay setup until VimEnter so copilot.lua does not attach to a startup buffer
  -- that Neovim is about to replace or unload.
  copilot.setup({
    panel = {
      enabled = true,
      auto_refresh = true,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-Tab>",
      },
      layout = {
        position = "right", -- | top | bottom | left | right
        ratio = 0.5,
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      debounce = 75,
      keymap = {
        accept = "<Tab>",
        -- accept_word = "<M-w>",
        -- accept_line = "<M-L>",
        next = "<C-n>",
        prev = "<C-p>",
        dismiss = "<esc>",
      },
    },
    filetypes = {
      -- yaml = false,
      -- markdown = false,
      -- help = false,
      -- gitcommit = false,
      -- gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      [".env"] = false,
      ["."] = false,
    },
    copilot_node_command = "node",
    server_opts_overrides = {},
  })
end

if vim.api.nvim_get_vvar("vim_did_enter") == 1 then
  setup_copilot()
else
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = setup_copilot,
  })
end
