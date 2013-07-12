require 'test_helper'
require 'pathname'
require 'fileutils'

describe GitMirror do

  let(:root) { (Pathname.new(__FILE__) + '../root').to_s }

  before do
    FileUtils.rm_f(root)
    ENV['GIT_MIRROR_ROOT'] = nil
  end

  describe 'root' do
    it 'uses the root specified' do
      mirror = GitMirror.new(root)
      mirror.root.to_s.must_equal root
    end

    it 'uses GIT_MIRROR_ROOT' do
      ENV['GIT_MIRROR_ROOT'] = root

      mirror = GitMirror.new
      mirror.root.to_s.must_equal root
    end

    it 'defaults to /var/git_mirror' do
      mirror = GitMirror.new
      mirror.root.to_s.must_equal '/var/git_mirror'
    end
  end

  describe 'update' do
    let(:mirror)   { GitMirror.new(root) }
    let(:repo_url) { 'git@github.com:zendesk/git_mirror.git' }
    let(:path)     { Pathname.new(root) + 'zendesk/git_mirror.git' }

    before { FileUtils.rm_rf(path) }

    describe 'when the repo is not mirrored' do
      before { mirror.update(repo_url) }

      it 'mirrors the repo' do
        assert path.directory?
        FileUtils.cd(path) do
          remotes = `git remote -v`.strip
          remotes.must_equal "origin\t#{repo_url} (fetch)\norigin\t#{repo_url} (push)"
          `git log -1`.strip.wont_be :empty?
        end
      end
    end

    describe 'when the repo is mirrored' do
      before do
        FileUtils.mkdir_p(path)
        FileUtils.cd(path) do
          `git init --bare && git remote add --mirror=fetch origin #{repo_url}`
        end
        mirror.update(repo_url)
      end

      it 'updates the mirror' do
        FileUtils.cd(path) do
          `git log -1`.strip.wont_be :empty?
        end
      end
    end
  end

  describe 'update_all' do
    let(:mirror)   { GitMirror.new(root) }
    let(:repo_url) { 'git@github.com:zendesk/git_mirror.git' }
    let(:paths)    { [Pathname.new(root) + 'zendesk/git_mirror.git', Pathname.new(root) + 'zendesk/git_mirror2.git'] }

    before do
      paths do |path|
        FileUtils.rm_rf(path)
        FileUtils.mkdir_p(path)
        FileUtils.cd(path) do
          `git init --bare && git remote add --mirror=fetch origin #{repo_url}`
        end
      end
    end

    it 'updates all the mirrors' do
      paths do |path|
        FileUtils.cd(path) do
          `git log -1`.strip.wont_be :empty?
        end
      end

    end

  end

end
