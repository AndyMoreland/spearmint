class Build < ActiveRecord::Base
  belongs_to :project
  before_create :set_waiting

  protected
  def set_waiting
    self.status = :waiting
  end
end
