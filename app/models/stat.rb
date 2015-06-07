class Stat < ActiveRecord::Base
  belongs_to :build

  serialize :data
end
