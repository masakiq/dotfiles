#!/usr/bin/env lua

local function execute_shell_command(cmd)
  local handle = io.popen(cmd)
  if not handle then
    return nil
  end
  local result = handle:read("*a")
  handle:close()
  return result
end

local function run_in_vim_plugin_dirs(callback)
  local vim_plugin_dirs = execute_shell_command('ls ~/.vim/plugged')
  if not vim_plugin_dirs then
    return
  end
  for dir in vim_plugin_dirs:gmatch("[^\r\n]+") do -- split by newline
    local path = "~/.vim/plugged/" .. dir
    local cmd = string.format('cd %s && lua -e "%s"', path, callback)
    os.execute(cmd)
  end
end

local callback_code = [[
  function repo_name()
    local handle = io.popen('git remote get-url origin')
    local remote = handle:read('*a'):gsub('%s+', '')
    handle:close()

    local remote_url = remote:gsub('%.git$', '')
    return remote_url:gsub('https://github.com/', '')
  end

  function commit()
    local handle = io.popen('git rev-parse HEAD')
    local commit_id = handle:read('*a'):gsub('%s+', '')
    handle:close()

    return commit_id
  end

  local repo = repo_name()
  local commit_id = commit()
  local plugin_declaration = string.format('Plug \'%s\', { \'commit\': \'%s\'', repo, commit_id)

  if repo == 'dracula/vim' then
    print(plugin_declaration .. ', \'as\': \'dracula\' }')
  elseif repo == 'masakiq/vim-ruby-fold' then
    print(plugin_declaration .. ', \'for\': \'ruby\' }')
  elseif repo == 'dart-lang/dart-vim-plugin' then
    print(plugin_declaration .. ', \'for\': \'dart\' }')
  elseif repo == 'maxmellon/vim-jsx-pretty' then
    print(plugin_declaration .. ', \'for\': [\'javascript\', \'typescript\'] }')
  elseif repo == 'rcmdnk/vim-markdown' then
    print(plugin_declaration .. ', \'for\': \'markdown\' }')
  elseif repo == 'neoclide/coc.nvim' then
    print(plugin_declaration .. ', \'do\': \'npm ci\' }')
  elseif repo == 'iamcco/markdown-preview.nvim' then
    -- ignore
  else
    print(plugin_declaration .. ' }')
  end
]]

run_in_vim_plugin_dirs(callback_code)
