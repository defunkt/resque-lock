Resque Lock
===========

A [Resque][rq] plugin. If you want only one instance of your job
running at a time, extend it with this module.

For example:

    class UpdateNetworkGraph
      extend Resque::Jobs::Locked

      def self.perform(repo_id)
        heavy_lifting
      end
    end

While other UpdateNetworkGraph jobs will be placed on the queue,
the Locked class will check Redis to see if any others are
executing with the same arguments before beginning. If another
is executing the job will be aborted.

If you want to define the key yourself you can override the
`lock` class method in your subclass, e.g.

    class UpdateNetworkGraph
      extend Resque::Jobs::Locked

      Run only one at a time, regardless of repo_id.
      def self.lock(repo_id)
        "network-graph"
      end

      def self.perform(repo_id)
        heavy_lifting
      end
    end

The above modification will ensure only one job of class
UpdateNetworkGraph is running at a time, regardless of the
repo_id. Normally a job is locked using a combination of its
class name and arguments.


Dependencies
------------

* Resque 1.7.0

[rq]: http://github.com/defunkt/resque
