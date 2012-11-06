require 'test/unit'
require 'resque'
require 'resque/plugins/lock'

$counter = 0

class LockTest < Test::Unit::TestCase
  class Job
    extend Resque::Plugins::Lock
    @queue = :lock_test

    def self.lock_timeout
      1
    end

    def self.perform
      raise "Woah woah woah, that wasn't supposed to happen"
    end
  end

  def setup
    Resque.redis.del('queue:lock_test')
    Resque.redis.del(Job.lock)
  end

  def test_lint
    assert_nothing_raised do
      Resque::Plugin.lint(Resque::Plugins::Lock)
    end
  end

  def test_version
    major, minor, patch = Resque::Version.split('.')
    assert_equal 1, major.to_i
    assert minor.to_i >= 17
    assert Resque::Plugin.respond_to?(:before_enqueue_hooks)
  end

  def test_lock
    3.times { Resque.enqueue(Job) }

    assert_equal 1, Resque.redis.llen('queue:lock_test')
  end

  def test_deadlock
    now = Time.now.to_i

    Resque.redis.set(Job.lock, now+60)
    Resque.enqueue(Job)
    assert_equal 0, Resque.redis.llen('queue:lock_test')

    Resque.redis.set(Job.lock, now-1)
    Resque.enqueue(Job)
    assert_equal 1, Resque.redis.llen('queue:lock_test')

    sleep 3
    Resque.enqueue(Job)
    assert_equal 2, Resque.redis.llen('queue:lock_test')
  end
end
