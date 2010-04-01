Gem::Specification.new do |s|
  s.name              = "resque-lock"
  s.version           = "0.1.0"
  s.date              = "2010-03-31"
  s.summary           = "A Resque plugin for ensuring only one instance of your job is running at a time."
  s.homepage          = "http://github.com/defunkt/resque-lock"
  s.email             = "chris@ozmm.org"
  s.authors           = [ "Chris Wanstrath" ]
  s.has_rdoc          = false

  s.files             = %w( README.md Rakefile LICENSE )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("test/**/*")

  s.description       = <<desc
A Resque plugin. If you want only one instance of your job
running at a time, extend it with this module.

For example:

    class UpdateNetworkGraph
      extend Resque::Jobs::Locked

      def self.perform(repo_id)
        heavy_lifting
      end
    end
desc
end
