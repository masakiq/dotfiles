#!/bin/sh

ln -s `pwd`/vim/.vimrc ~/.vimrc
ln -s `pwd`/vim/.vimrc-light ~/.vimrc-light

mkdir ~/.config/nvim
ln -s `pwd`/vim/init.lua ~/.config/nvim/init.lua

mkdir ~/.vim/functions
for file in `pwd`/vim/functions/*; do
  file_name=`basename $file`
  ln -s $file ~/.vim/functions/$file_name
done

mkdir ~/.config/nvim/lua
for file in `pwd`/vim/lua/*; do
  if [ -d "$file" ]; then
    continue
  fi
  file_name=`basename $file`
  ln -s $file ~/.config/nvim/lua/$file_name
done

mkdir ~/.config/nvim/plugin
for file in `pwd`/vim/plugin/*; do
  file_name=`basename $file`
  ln -s $file ~/.config/nvim/plugin/$file_name
done

ln -s `pwd`/vim/.vimrc ~/.ideavimrc

mkdir ~/.config/direnv
ln -s `pwd`/direnv/direnv.toml ~/.config/direnv/direnv.toml

mkdir ~/.config/wezterm
ln -s `pwd`/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua


ln -s `pwd`/tig/.tigrc ~/.tigrc

ln -s `pwd`/tmux/.tmux.conf ~/.tmux.conf

ln -s `pwd`/alacritty/.alacritty.yml ~/.alacritty.yml

ln -s `pwd`/alacritty/.stylua.toml ~/.stylua.toml

mkdir ~/Library/Application\ Support/iTerm2/Scripts/AutoLaunch
ln -s `pwd`/iTerm2/Scripts/AutoLaunch/launch_alacritty.py ~/Library/Application\ Support/iTerm2/Scripts/AutoLaunch/launch_alacritty.py
