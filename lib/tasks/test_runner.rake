namespace :test_runner do
  require 'test_runner/main'
  
  desc "Start test-runner server"
  task server: :environment do
    TestRunner::Main.new.run
  end

end
