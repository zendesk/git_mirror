require 'pathname'
require 'fileutils'

class GitMirror
  attr_accessor :root

  def initialize(root = ENV['GIT_MIRROR_ROOT'] || '/var/git_mirror')
    @root = Pathname.new(root)
  end

  def prepare_root
    root.mkpath
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
    root + repo_url.split(/github.com./, 2).last
  end

  def update_all
    Pathname.glob(root + '**/HEAD').each do |head|
      update_local(head.parent)
    end
  end

  def update_local(path)
    FileUtils.cd(path) do
      execute "git fetch --prune --quiet"
      execute "git fetch --tags --quiet"
    end
  end

  def execute(command)
    prepare_root
    puts command
    system(command)
  end
end
