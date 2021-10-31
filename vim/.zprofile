# For coc-solargraph
# coc-solargraph uses solargraph-utils, which spawns an additional shell process. It spawns zsh as a login shell, which bypasses your zshrc.
# https://github.com/neoclide/coc-solargraph/issues/12#issuecomment-528942686
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
