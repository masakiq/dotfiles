local M = {}

function M.setup()
  vim.g.dotfiles_skip_vim_plug = 1
  vim.cmd([[
    source $HOME/.vimrc
  ]])
end

return M
