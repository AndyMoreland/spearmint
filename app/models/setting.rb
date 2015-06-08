class Setting < ActiveRecord::Base
  belongs_to :user_with_token, foreign_key: :user_with_token, class_name: "User"
  belongs_to :project

  validates :project_id, uniqueness: true
end
