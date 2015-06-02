module TestRunner
  class JSComplexityJob < Job::Default

    def execute!(build)
      self.issues = []
      self.stats = []

      # Keeping this framework but complexity-report is actually capable
      # of recursively searching for files in the project directory, as
      # well as handling CoffeeScript files, etc.
      src = Rails.root.join 'clients', build.project.full_name, build.commit
      result = Docker.run("node #{Rails.root.join('node_modules', 'complexity-report', 'src', 'index.js')} --format json #{src}", build)

      # return if result.empty? # will be empty if file is not valid JS

      # complexity report is way too verbose at the moment, keep only global averages for now
      stat_report = Stat.new
      stat_report.source = 'JSComplexity'
      stat_report.build_id = build.id
      stat_report.data = JSON.parse(result).tap { |raw_stats| raw_stats.delete("reports") }
      self.stats << stat_report
    end

  end
end
