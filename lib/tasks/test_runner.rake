namespace :test_runner do
  require 'test_runner/main'
  
  desc "Start test-runner server"
  task server: :environment do
    TestRunner::Main.new.run
  end

  desc "Recover jobs stuck in 'queued' state (stop using kill -9, ffs)"
  task unstick: :environment do
    Build.where(status: :queued).update_all(status: :waiting)
  end

end
