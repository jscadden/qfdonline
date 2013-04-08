class CreateHoqLists < ActiveRecord::Migration
  def self.up
    create_table :hoq_lists do |t|
      t.references :qfd
      t.references :hoq

      t.timestamps
    end
  end

  def self.down
    drop_table :hoq_lists
  end
end
