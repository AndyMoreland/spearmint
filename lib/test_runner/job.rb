module TestRunner
  class Job
    
    def execute!(sources)
      raise 'abstract'      
    end

    def issues
      raise 'Job not yet run' unless @issues
      @issues
    end

    def success?
      raise 'Job not yet run' unless @issues
      @issues.none? { |issue| issue.fatal? }
    end
  end
end
