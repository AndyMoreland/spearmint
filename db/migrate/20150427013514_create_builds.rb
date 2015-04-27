class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.string :title
      t.string :status
      t.references :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
