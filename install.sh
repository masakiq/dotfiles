#!/bin/sh

ln -sf `pwd`/vim/.vimrc ~/.vimrc
ln -sf `pwd`/vim/.vimrc-light ~/.vimrc-light

mkdir -p ~/.config/nvim
ln -sf `pwd`/vim/init.lua ~/.config/nvim/init.lua

mkdir -p ~/.vim/functions
for file in `pwd`/vim/functions/*; do
  file_name=`basename $file`
  ln -sf $file ~/.vim/functions/$file_name
done

rm -rf ~/.config/nvim/lua
rm -rf ~/.config/nvim/plugin
./linktree.sh `pwd`/vim/lua ~/.config/nvim/lua
./linktree.sh `pwd`/vim/plugin ~/.config/nvim/plugin

mkdir -p ~/.config/direnv
ln -sf `pwd`/direnv/direnv.toml ~/.config/direnv/direnv.toml

mkdir -p ~/.config/efm-langserver
ln -sf `pwd`/efm-langserver/config.yaml ~/.config/efm-langserver/config.yaml

ln -sf `pwd`/tig/.tigrc ~/.tigrc
