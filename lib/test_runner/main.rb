require_relative 'basic_build'
require_relative 'worker'

module TestRunner
  class Main

    N_WORKERS = 16

    attr_accessor :builds

    def initialize
      @builds = Queue.new
    end
    
    def run
      puts "TestRunner::Main running"
            
      workers = N_WORKERS.times.map do
        Thread.new { Worker.new.run(@builds) }
      end

      # TODO loop and add jobs to queue as they appear
      @builds.push BasicBuild.new(Project.first, 'master') # test build
      
      workers.each { |th| th.join } # TODO: on INT/TERM, signal workers to safely shutdown
    end
  end  
end
