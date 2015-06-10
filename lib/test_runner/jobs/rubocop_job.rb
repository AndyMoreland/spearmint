module TestRunner
  class RuboCopJob < Job::Default

    def execute!(build)
      self.issues = []
      self.stats = []
      result = Docker.run("bundle exec rubocop --format json --config #{
                            Rails.root.join('rubocop.yml')} #{build.build_directory_path
                          }", build)
      result = JSON.parse(result)
      result['files'].each do |file|
        contents = File.readlines file['path']
        filename = Job.relative_filename(build, file['path'])
        file['offenses'].each do |offense|
          case offense['severity']
          when 'refactor'
            issue = Issue::Refactor.new
          when 'convention'
            issue = Issue::Convention.new
          when 'warning'
            issue = Issue::Warning.new
          when 'error'
            issue = Issue::Error.new
          when 'fatal'
            issue = Issue::Abort.new # TODO might need to rejigger this mapping a bit
          else
            # raise '[RubyCopJob] unknown severity level'
            next
          end

          issue.source = 'RuboCop'
          issue.build_id = build.id
          issue.file = filename
          issue.line = offense['location']['line']
          issue.line_contents = contents[issue.line - 1] # ugh indexing
          issue.character = offense['location']['column']
          # TODO do something with offense['location']['length'] for fancy highlights
          issue.message = offense['message']

          self.issues << issue
        end
      end
    end
  end
end
