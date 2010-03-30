class CreateHoqs < ActiveRecord::Migration
  def self.up
    create_table :hoqs do |t|
      t.string :name
      t.references :qfd

      t.timestamps
    end
  end

  def self.down
    drop_table :hoqs
  end
end
