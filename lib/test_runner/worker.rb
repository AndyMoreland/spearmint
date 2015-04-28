module TestRunner
  class Worker
    def run(queue)
      loop do
        build = queue.pop
        build.fetch!
        build.execute!
        puts "#{build.success?} => #{build.issues}" # TODO parse issues better and log them properly
        build.cleanup!
      end
    end
  end
end
