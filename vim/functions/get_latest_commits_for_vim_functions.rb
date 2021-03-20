#!/usr/bin/env ruby

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
  puts "Plug '#{repo_name}', { 'commit': '#{commit}' }"
end
