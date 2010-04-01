class CreateRequirementsLists < ActiveRecord::Migration
  def self.up
    create_table :requirements_lists do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :requirements_lists
  end
end
