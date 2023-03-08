#!/bin/sh
ln -s `pwd`/vim/.vimrc ~/.vimrc
mkdir ~/.config/nvim
ln -s `pwd`/vim/.vimrc ~/.config/nvim/init.vim
mkdir ~/.config/direnv
ln -s `pwd`/direnv/direnv.toml ~/.config/direnv/direnv.toml
ln -s `pwd`/vim/.vimrc ~/.ideavimrc
mkdir ~/.vim/functions
ln -s `pwd`/vim/functions/normal ~/.vim/functions/normal
ln -s `pwd`/vim/functions/visual ~/.vim/functions/visual
ln -s `pwd`/vim/functions/notes ~/.vim/functions/notes
ln -s `pwd`/vim/functions/command_snippets ~/.vim/functions/command_snippets
ln -s `pwd`/vim/functions/open_github.rb ~/.vim/functions/open_github.rb
ln -s `pwd`/vim/functions/search_shopify_graphql_api_document_path.rb  ~/.vim/functions/search_shopify_graphql_api_document_path.rb
ln -s `pwd`/vim/functions/copy_github_compare_url.rb ~/.vim/functions/copy_github_compare_url.rb
ln -s `pwd`/vim/functions/git_add_commit_push.rb ~/.vim/functions/git_add_commit_push.rb
ln -s `pwd`/vim/functions/plug_get_latest_commits.rb ~/.vim/functions/plug_get_latest_commits.rb
ln -s `pwd`/vim/.zprofile ~/.zprofile
ln -s `pwd`/tig/.tigrc ~/.tigrc
ln -s `pwd`/tmux/.tmux.conf ~/.tmux.conf
ln -s `pwd`/alacritty/.alacritty.yml ~/.alacritty.yml
mkdir ~/Library/Application\ Support/iTerm2/Scripts/AutoLaunch
ln -s `pwd`/iTerm2/Scripts/AutoLaunch/launch_alacritty.py ~/Library/Application\ Support/iTerm2/Scripts/AutoLaunch/launch_alacritty.py
ln -s `pwd`/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s `pwd`/vscode/settings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json
ln -s `pwd`/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
ln -s `pwd`/vscode/keybindings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/keybindings.json
