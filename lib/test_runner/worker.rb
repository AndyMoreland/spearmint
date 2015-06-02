require_relative 'job_default'

module TestRunner
  class Worker
    def run(queue)
      loop do
        build = queue.pop
        break if build == :shutdown
        puts 'Build starting.'
        build.fetch!

        if false
          # TODO check for and execute custom jobs
        else
          build.execute! Job::Default.jobs
        end

        if build.success?
          build.status = :passed
        else
          build.status = :failed
        end

        finished = build.transaction do
          build.save!
          build.issues.each { |issue| issue.save! }
          build.stats.each { |stat| stat.save! }
        end

        if finished
          puts 'Build finished.'
        else
          puts 'Build error.'
        end

        build.cleanup!
      end
    end
  end
end
