module Janky
  class BuildRequest
    def self.handle(repo_uri, branch_name, pusher, commit, compare, room)
      repos = Repository.find_all_by_uri(repo_uri)
      repos.each do |repo|
        begin
          new(repo, branch_name, pusher, commit, compare, room).handle
        rescue Janky::Error => boom
          Exception.report(boom, :repo => repo.name)
        end
      end

      repos.size
    end

    def initialize(repo, branch_name, pusher, commit, compare, room)
      @repo        = repo
      @branch_name = branch_name
      @pusher      = pusher
      @commit      = commit
      @compare     = compare
      @room        = room
    end

    def handle
      current_build = commit.last_build
      build = branch.build_for(commit, @pusher, @room, @compare)

      if !current_build || (current_build && current_build.red?)
        if @repo.enabled?
          build.run
        end
      end
    end

    def branch
      @repo.branch_for(@branch_name)
    end

    def commit
      @repo.commit_for(
        :sha1         => @commit.sha1,
        :url          => @commit.url,
        :message      => @commit.message,
        :author       => @commit.author,
        :committed_at => @commit.committed_at
      )
    end
  end
end
