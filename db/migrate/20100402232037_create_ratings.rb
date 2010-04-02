class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.float :value
      t.references :primary_requirement
      t.references :secondary_requirement

      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
