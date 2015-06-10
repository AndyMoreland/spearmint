module TestRunner
  module Docker
    class << self
      def run(cmd, build, verbose: false)
        if ENV['SPEARMINT_DISABLE_DOCKER']
          puts cmd
          res = exec_cmd cmd
        else
          dir = build.build_directory_path
          res = exec_cmd %{docker run --rm -v #{dir}:#{mount_paths dir} #{build.build_image_name} /bin/bash -c "#{mount_paths cmd}"}
        end
        return res if verbose
        res[:output]
      end

      def image(cmd, build, base: :spearmint, verbose: false)
        if ENV['SPEARMINT_DISABLE_DOCKER']
          res = exec_cmd cmd
        else
          name = build.build_image_name
          dir = build.build_directory_path

          res = exec_cmd %{docker run -v #{dir}:#{mount_paths dir} --name #{name}-container #{base} /bin/bash -c "#{mount_paths cmd}"}
          `docker commit #{name}-container #{name}`
          `docker rm -f #{name}-container`
        end

        return res if verbose
        res[:output]
      end

      def cleanup(build)
        `docker rmi -f #{build.build_image_name}` unless ENV['SPEARMINT_DISABLE_DOCKER']
      end

      def mount_paths(abs_path)
        abs_path.to_s.gsub(Rails.root.to_s, '/spearmint')
      end

      protected

      def exec_cmd(cmd)
        # execute and catch
        res = nil
        begin
          out = `#{cmd} 2>&1`
        rescue
          res = { error: 1, output: "[Failed to execute. Malformed command or file not found.]" }
        else
          res = { error: $?.to_i, output: out }
        end
        res
      end
    end
  end
end
