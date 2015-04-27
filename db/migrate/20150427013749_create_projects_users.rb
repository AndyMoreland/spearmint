class CreateProjectsUsers < ActiveRecord::Migration
  def change
    create_table :projects_users do |t|
      t.references :projects, :index => true, :foreign_key => true
      t.references :users, :index => true, :foreign_key => true
    end
  end
end
