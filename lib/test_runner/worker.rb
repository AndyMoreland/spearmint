require_relative 'job_default'

module TestRunner
  class Worker
    def run(queue)
      loop do
        build = queue.pop
        project = build.project
        client = project.github_client
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
          
          # For builds that come from pull requests, synchronize status/comments
          if build.pull_id
            changed_files = build.get_changed_filenames!
            changed_lines_by_file = build.get_changed_lines_by_file!

            build.issues
              .select { |i| i.changed_in_build?(changed_files, changed_lines_by_file) }
              .each do |issue|
              issue.add_to_github!(client, project.full_name, build.pull_id, build.commit)
            end
            
            build.sync_status_to_github!
          end
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
