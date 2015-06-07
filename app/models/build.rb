class Build < ActiveRecord::Base
  belongs_to :project
  before_create :set_waiting
  has_many :issues
  has_many :stats

  protected
  def set_waiting
    self.status = :waiting
  end
end
