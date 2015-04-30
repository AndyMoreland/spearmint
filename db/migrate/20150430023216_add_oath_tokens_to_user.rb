class AddOathTokensToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :github_token
      t.string :client_secret
      t.string :client_token
      t.datetime :expires_at
    end
  end
end
