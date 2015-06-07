class Setting < ActiveRecord::Base
  has_one :user_with_token, foreign_key: :user_with_token, class_name: "User"
  has_one :project
end
