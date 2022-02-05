#!/usr/bin/env ruby
# frozen_string_literal: true

def execute_in_vim_dir(&block)
  vim_plugs = `ls ~/.vim/plugged`.split("\n")
  vim_plugs.each do |dir|
    Dir.chdir("#{Dir.home}/.vim/plugged/#{dir}", &block)
  end
end

def repo_name
  remote = `git remote get-url origin`.strip
  remote_url = remote.sub(/\.git\z/, '')
  remote_url.gsub('https://github.com/', '')
end

def commit
  `git rev-parse HEAD`.strip
end

execute_in_vim_dir do
  case repo_name
  when 'dracula/vim'
    puts "Plug '#{repo_name}', { 'commit': '#{commit}', 'as': 'dracula' }"
  when 'masakiq/vim-ruby-fold'
    puts "Plug '#{repo_name}', { 'commit': '#{commit}', 'for': 'ruby' }"
  when 'dart-lang/dart-vim-plugin'
    puts "Plug '#{repo_name}', { 'commit': '#{commit}', 'for': 'dart' }"
  when 'maxmellon/vim-jsx-pretty'
    puts "Plug '#{repo_name}', { 'commit': '#{commit}', 'for': ['javascript', 'typescript'] }"
  when 'rcmdnk/vim-markdown'
    puts "Plug '#{repo_name}', { 'commit': '#{commit}', 'for': 'markdown' }"
  when 'iamcco/markdown-preview.nvim', 'masakiq/vim-markdown-composer'
    # ignore
  else
    puts "Plug '#{repo_name}', { 'commit': '#{commit}' }"
  end
end
