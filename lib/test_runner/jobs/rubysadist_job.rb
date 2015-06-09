module TestRunner
    class JSComplexityJob < Job::Default

        def execute!(build)
            self.issues = []
            self.stats = []

            # given more time we would allow user to configure options here
            project_dir = Rails.root.join 'clients', build.project.full_name, build.commit
            flog_result = Docker.run("find #{project_dir} -name \\*.rb | xargs bundle exec flog --all --continue --quiet --methods-only", build)
            flay_result = Docker.run("find #{project_dir} -name \\*.rb | xargs bundle exec flay -\\#", build)
            puts "find #{project_dir} -name \\*.rb | xargs bundle exec flay -\\#"
            puts flay_result

            rel_path_offset = Docker.mount_paths(project_dir).length + 1

            # will be empty if no ruby files in directory
            unless flog_result.empty?
                stat_report = Stat.new
                stat_report.source = 'RubyFlog'
                stat_report.build_id = build.id
                stat_report.data = parse_flog_output(flog_result)

                self.stats << stat_report
            end

            # will be empty if no ruby files in directory
            unless flay_result.empty?
                stat_report = Stat.new
                stat_report.source = 'RubyFlay'
                stat_report.build_id = build.id
                stat_report.data = parse_flay_output(flay_result)

                self.stats << stat_report
            end

        end

        def parse_flog(flog_str)
            flog_str[0..-2].to_f
        end

        def parse_flog_output(output)
            tokens = output.lines.map { |line| line.split }
            {
                "total" => parse_flog(tokens[0][0]),
                "average" => parse_flog(tokens[1][0]),
                "entries" => tokens.drop(3).map do |row|
                    {
                        "flog" => parse_flog(row[0]),
                        "method" => row[1],
                        "path" => row[2]
                    }
                end
            }
        end

        def parse_flay_loc(loc_str)
            tokens = loc_str.strip.split(":")
            {
                "path" => tokens[0],
                "line" => tokens[1].to_i
            }
        end

        def parse_flay_output(output)
            entries = output.split("\n\n")
            {
                "total" => entries[0].split("=")[1].to_i,
                "entries" => entries.drop(1).map do |entry|
                    lines = entry.split("\n")
                    matches = /(\w+) code found in :(\w+) \(mass(?:\*2)? = (\d+)\)/.match(lines[0])
                    {
                        "match_type" => matches[1].downcase.to_sym,
                        "sexp_type" => matches[2].to_sym,
                        "mass" => matches[3].to_i,
                        "first" => parse_flay_loc(lines[1]),
                        "second" => parse_flay_loc(lines[2])
                    }
                end
            }
        end
    end
end
