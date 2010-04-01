class CreateHoqs < ActiveRecord::Migration
  def self.up
    create_table :hoqs do |t|
      t.string :name
      t.references :hoq_list
      t.integer :position
      t.references :primary_requirements_list
      t.references :secondary_requirements_list

      t.timestamps
    end
  end

  def self.down
    drop_table :hoqs
  end
end
