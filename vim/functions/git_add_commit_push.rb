#!/usr/bin/env ruby

path = `git rev-parse --show-toplevel`.chomp
repo = path.split('/').last
allow_repos = `cat ~/.config/allow_auto_push_repo.txt`.split("\n")

unless allow_repos.include?(repo)
  puts 'Do not allow git push on this repository'
  exit 1
end

`git add .`
`git commit -m 'commit'`
`git push`
