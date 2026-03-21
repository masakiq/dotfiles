#!/bin/sh

mkdir -p ~/.config/nvim
ln -sf `pwd`/vim/init.lua ~/.config/nvim/init.lua
ln -sf `pwd`/vim/lazy-lock.json ~/.config/nvim/lazy-lock.json

rm -f ~/.vimrc
rm -f ~/.vimrc-light
rm -rf ~/.vim/functions

rm -rf ~/.config/nvim/lua
rm -rf ~/.config/nvim/plugin
./linktree.sh `pwd`/vim/lua ~/.config/nvim/lua
./linktree.sh `pwd`/vim/plugin ~/.config/nvim/plugin

mkdir -p ~/.config/direnv
ln -sf `pwd`/direnv/direnv.toml ~/.config/direnv/direnv.toml

mkdir -p ~/.config/efm-langserver
ln -sf `pwd`/efm-langserver/config.yaml ~/.config/efm-langserver/config.yaml

ln -sf `pwd`/tig/.tigrc ~/.tigrc

mkdir -p ~/.config/diffview
ln -sf `pwd`/diffview/config.toml ~/.config/diffview/config.toml
