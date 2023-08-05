#!/bin/sh

ln -s `pwd`/vim/.vimrc ~/.vimrc

mkdir ~/.config/nvim
ln -s `pwd`/vim/.vimrc ~/.config/nvim/init.vim

mkdir ~/.vim/functions
for file in `pwd`/vim/functions/*; do
  file_name=`basename $file`
  ln -s $file ~/.vim/functions/$file_name
done

mkdir ~/.vim/lua_scripts
for file in `pwd`/vim/lua_scripts/*; do
  file_name=`basename $file`
  ln -s $file ~/.vim/lua_scripts/$file_name
done

ln -s `pwd`/vim/.vimrc ~/.ideavimrc

ln -s `pwd`/vim/.zprofile ~/.zprofile

mkdir ~/.config/direnv
ln -s `pwd`/direnv/direnv.toml ~/.config/direnv/direnv.toml

ln -s `pwd`/tig/.tigrc ~/.tigrc

ln -s `pwd`/tmux/.tmux.conf ~/.tmux.conf

ln -s `pwd`/alacritty/.alacritty.yml ~/.alacritty.yml

mkdir ~/Library/Application\ Support/iTerm2/Scripts/AutoLaunch
ln -s `pwd`/iTerm2/Scripts/AutoLaunch/launch_alacritty.py ~/Library/Application\ Support/iTerm2/Scripts/AutoLaunch/launch_alacritty.py

ln -s `pwd`/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s `pwd`/vscode/settings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json
ln -s `pwd`/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
ln -s `pwd`/vscode/keybindings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/keybindings.json
