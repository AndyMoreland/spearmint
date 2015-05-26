class Issue < ActiveRecord::Base

  belongs_to :build

  class Warning < Issue
    def initialize
      super
      self.fatal = false
    end
  end

  class Error < Issue
    def initialize
      super
      self.fatal = true
    end
  end

  class Abort < Issue
    def initialize
      super
      self.fatal = true
    end
  end

  def self.errors
    where(type: Error)
  end

  def self.warnings
    where(type: Warning)
  end

  def self.aborts
    where(type: Abort)
  end
end


