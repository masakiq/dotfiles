#!/usr/bin/env ruby

absolute_file_path = ARGV[0]
line = ARGV[1]

def repository_url
  remote = `git remote get-url origin`.strip
  remote_url = remote.sub(/\.git\z/, '')

  return remote_url if remote_url.start_with?('https://github.com')
  return remote_url.sub(/\Agit@github\.com:/, 'https://github.com/') if remote_url.start_with?('git@github.com')

  remote_url.sub(%r{\Assh://git@github\.com}, 'https://github.com') if remote_url.start_with?('ssh://git@github.com')
end

def commit
  `git show -s --format=%h`.strip
end

def relative_file_path(absolute_file_path)
  repository_root_path = `git rev-parse --show-toplevel`.strip
  absolute_file_path.sub(repository_root_path, '')
end

github_url =
  if absolute_file_path && line
    "#{repository_url}/blob/#{commit}#{relative_file_path(absolute_file_path)}#{line}"
  else
    repository_url
  end

`printf #{github_url} | pbcopy`
`open #{github_url}`
exit 0
