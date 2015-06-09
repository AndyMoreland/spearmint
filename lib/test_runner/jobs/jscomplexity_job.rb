module TestRunner
    class JSComplexityJob < Job::Default

        def execute!(build)
            self.issues = []
            self.stats = []

            # complexity-report actually capable of handling CoffeeScript files, etc.
            # given more time we would let settings configure all of these options
            project_dir = build.build_directory_path
            result = Docker.run("node #{Rails.root.join('node_modules', 'complexity-report', 'src', 'index.js')} --ignoreerrors --coffeescript --format json #{project_dir}", build)

            return if result.empty? # will be empty if file is not valid JS

            rel_path_offset = Docker.mount_paths(project_dir).length + 1

            stat_report = Stat.new
            stat_report.source = 'JSComplexity'
            stat_report.build_id = build.id
            begin
                # get rid of extra shit
                stat_report.data = JSON.parse(result).tap {
                    |raw_stats|
                    raw_stats['reports'].each do |report|
                        report.delete 'aggregate'
                        report.delete 'functions'
                        report.delete 'dependencies'
                        report['path'] = report['path'][rel_path_offset..-1]
                    end
                    raw_stats['num_files'] = raw_stats['reports'].length
                    raw_stats.delete 'visibilityMatrix'
                    raw_stats.delete 'adjacencyMatrix'
                }
            rescue JSON::ParserError
                stat_report.data = {
                    "error" => result
                }
            end
            self.stats << stat_report
        end

    end
end
