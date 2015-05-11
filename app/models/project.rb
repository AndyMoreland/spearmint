class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :builds

  def github_url
    "https://github.com/#{full_name}"
  end
end
