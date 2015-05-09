module TestRunner
  class Job

    attr_writer :issues
    
    def execute!(sources)
      raise 'abstract'      
    end

    def issues
      @issues or raise 'Job not yet run'
    end

    def success?
      issues.none? { |issue| issue.fatal? }
    end
  end
end
