require 'logger'
require_relative 'worker'
require_relative 'runnable'

module TestRunner

  class Main

    N_WORKERS = 4
    N_SECONDS_PER_POLL = 5

    attr_accessor :builds

    def initialize
      @builds = Queue.new
    end

    def run
      puts "TestRunner::Main starting up..."
      puts "Docker is DISABLED. Running all commands locally..." if ENV['SPEARMINT_DISABLE_DOCKER']

      Thread.abort_on_exception = true # who thought silently swallowing errors was a good idea
      Build.instance_eval { include TestRunner::Runnable }

      workers = N_WORKERS.times.map do
        Thread.new { Worker.new.run(@builds) }
      end

      ['SIGINT', 'SIGTERM'].each do |signal|
        trap signal do
          puts "\nShutdown scheduled."
          puts 'Cleaning up...'
          until @builds.empty?
            build = @builds.pop
            build.status = :waiting
            build.save
          end
          puts 'Waiting for active builds to finish...'
          N_WORKERS.times { @builds.push :shutdown }
          workers.each { |th| th.join }
          puts 'All done.'
          exit 0
        end
      end

      puts "Now listening for new builds."
      sleep 3

      loop do
        todo = Build.where status: :waiting
        todo.each do |build|
          build.status = :queued
          build.save and @builds.push(build)
        end
        sleep N_SECONDS_PER_POLL
      end

      workers.each { |th| th.join }
    end
  end
end
