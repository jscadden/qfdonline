class CreateRequirements < ActiveRecord::Migration
  def self.up
    create_table :requirements do |t|
      t.string :name
      t.integer :position
      t.float :weight
      t.float :relative_weight
      t.references :requirements_list

      t.timestamps
    end
  end

  def self.down
    drop_table :requirements
  end
end
