class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :file
      t.integer :line
      t.integer :character
      t.string :message
      t.boolean :fatal

      t.references :build, index: true, foreign_key: true
      t.string :type, null: false
      
      t.timestamps null: false
    end
  end
end
