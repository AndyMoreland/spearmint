require_relative 'jslint_job'

module TestRunner
  class Worker
    def run(queue)
      loop do
        build = queue.pop
        break if build == :shutdown
        puts 'Build starting.'
        build.fetch!
        build.execute! [ JSLintJob.new ] # TODO allow changing job list

        if build.success?
          build.status = :passed
        else
          build.status = :failed
        end

        finished = build.transaction do
          build.save!
          build.issues.each { |issue| issue.save! }
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
