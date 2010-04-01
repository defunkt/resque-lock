require 'test/unit'
require 'resque'
require 'resque/plugins/lock'

$hooks = []

class Job
  extend Resque::Plugins::Lock
  @queue = :test

  def self.perform
    $hooks << :perform
    sleep 1
  end
end

class LockTest < Test::Unit::TestCase
  def test_version
    assert_equal '1.7.0', Resque::Version
  end

  def test_lock
    2.times { Resque.enqueue(Job) }
    worker = Resque::Worker.new(:test)

    workers = []
    workers << Thread.new { worker.work(0) }
    workers << Thread.new { worker.work(0) }
    workers.each { |t| t.join }

    assert_equal 1, $hooks.size
  end
end
