require_relative 'job_default'
require 'pry'

module TestRunner
  class Worker
    def run(queue)
      loop do
        build = queue.pop
        break if build == :shutdown
        puts 'Build starting.'
        project = build.project

        build.fetch!
        build.build! # unfortunate naming, sorry

        aborted = (build.status == :build_script_failed)

        unless aborted
          build.test!
          build.rm_ignored!

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
        end

        begin

          build.transaction do
            build.save!
            unless aborted
              build.issues.each { |issue| issue.save! }
              build.stats.each { |stat| stat.save! }
            end

            # For builds that come from pull requests, synchronize status/comments
            if build.pull_id
              changed_files = build.get_changed_filenames!
              changed_lines_by_file = build.get_changed_lines_by_file!

              unless aborted
                client = project.github_client
                build.issues
                  .select { |i| i.changed_in_build?(changed_files, changed_lines_by_file) }
                  .each { |issue| issue.add_to_github!(client, project.full_name, build.pull_id, build.commit) }
              end

              build.sync_status_to_github!
            end
          end
        rescue Exception => e
          puts "Build failed: #{e.message}"
          puts e.backtrace
        else
          puts "Build finished successfully."
        ensure
          build.cleanup!
        end
      end
    end
  end
end
