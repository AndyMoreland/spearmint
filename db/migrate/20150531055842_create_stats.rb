class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.string :job
      t.text :data, null: false

      t.references :build, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
