require 'pathname'

class GitMirror
  def initialize
    @root = Pathname.new(ENV['GIT_MIRROR_ROOT'] || '/var/git_mirror')
  end

  def prepare_root
    @root.mkpath
  end

  def update(repo_url)
    mirror(repo_url) unless has_mirror?(repo_url)
    update_local(local_path_for(repo_url))
  end

  def mirror(repo_url)
    return if has_mirror?(repo_url)
    execute "git clone --mirror --quiet #{repo_url} #{local_path_for(repo_url)}"
  end

  def has_mirror?(repo_url)
    local_path_for(repo_url).directory?
  end

  def local_path_for(repo_url)
    @root + repo_url.split(/github.com./, 2).last
  end

  def update_all
    Pathname.glob(@root + '**/HEAD').each do |head|
      update_local(head.parent)
    end
  end

  def update_local(path)
    execute "git fetch --prune --quiet #{path}"
  end

  def execute(command)
    prepare_root
    puts command
    system(command)
  end
end
