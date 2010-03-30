class CreateRequirements < ActiveRecord::Migration
  def self.up
    create_table :requirements do |t|
      t.string :name
      t.references :hoq

      t.timestamps
    end
  end

  def self.down
    drop_table :requirements
  end
end
