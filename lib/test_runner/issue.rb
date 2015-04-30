module TestRunner
  class Issue

    attr_reader :line, :character, :message, :fatal
    
    def fatal?
      @fatal
    end

    def initialize file: nil, line: nil, character: nil, message: "unknown error", fatal: true
      @file = file
      @line = line
      @character = character
      @message = message
      @fatal = fatal
    end
  end
end
