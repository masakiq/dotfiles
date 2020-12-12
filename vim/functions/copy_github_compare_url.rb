#!/usr/bin/env ruby

def repository_url
  remote = `git remote get-url origin`.strip
  remote_url = remote.sub(/\.git\z/, '')

  return remote_url if remote_url.start_with?('https://github.com')
  return remote_url.sub(/\Agit@github\.com:/, 'https://github.com/') if remote_url.start_with?('git@github.com')

  remote_url.sub(%r{\Assh://git@github\.com}, 'https://github.com') if remote_url.start_with?('ssh://git@github.com')
end

github_compare_url = "#{repository_url}/compare/commit..commit"

`printf #{github_compare_url} | pbcopy`
exit 0
