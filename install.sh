#!/bin/sh
ln -s `pwd`/vim/.vimrc ~/.vimrc
ln -s `pwd`/vim/.vimrc ~/.config/nvim/init.vim
ln -s `pwd`/vim/.vimrc ~/.ideavimrc
mkdir ~/.vim/functions
ln -s `pwd`/vim/functions/normal ~/.vim/functions/normal
ln -s `pwd`/vim/functions/visual ~/.vim/functions/visual
ln -s `pwd`/vim/functions/open_github.rb ~/.vim/functions/open_github.rb
ln -s `pwd`/vim/functions/copy_github_compare_url.rb ~/.vim/functions/copy_github_compare_url.rb
ln -s `pwd`/tig/.tigrc ~/.tigrc
ln -s `pwd`/tmux/.tmux.conf ~/.tmux.conf
ln -s `pwd`/alacritty/.alacritty.yml ~/.alacritty.yml
mkdir ~/Library/Application\ Support/iTerm2/Scripts/AutoLaunch
ln -s `pwd`/iTerm2/Scripts/AutoLaunch/launch_alacritty.py ~/Library/Application\ Support/iTerm2/Scripts/AutoLaunch/launch_alacritty.py
ln -s `pwd`/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s `pwd`/vscode/settings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json
ln -s `pwd`/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
ln -s `pwd`/vscode/keybindings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/keybindings.json
