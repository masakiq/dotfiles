#!/bin/sh
ln -s `pwd`/vim/.vimrc ~/.vimrc
ln -s `pwd`/vim/.vimrc ~/.config/nvim/init.vim
ln -s `pwd`/vim/.vimrc ~/.ideavimrc
mkdir ~/.vim/functions
ln -s `pwd`/vim/functions/normal ~/.vim/functions/normal
ln -s `pwd`/vim/functions/visual ~/.vim/functions/visual
ln -s `pwd`/tig/.tigrc ~/.tigrc
ln -s `pwd`/tmux/.tmux.conf ~/.tmux.conf
ln -s `pwd`/alacritty/.alacritty.yml ~/.alacritty.yml
ln -s `pwd`/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s `pwd`/vscode/settings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json
ln -s `pwd`/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
ln -s `pwd`/vscode/keybindings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/keybindings.json
