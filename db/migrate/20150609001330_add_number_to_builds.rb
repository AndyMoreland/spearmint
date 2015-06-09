class AddNumberToBuilds < ActiveRecord::Migration
  def up
    add_column :builds, :number, :integer

    Project.all.each do |p|
      p.builds.each_with_index do |b, i|
        b.number = i + 1
        b.save!
      end
    end

    change_column :builds, :number, :integer, null: false
    add_index :builds, [:project_id, :number], unique: true
  end

  def down
    remove_column :builds, :number
  end
end
