class CreateQfds < ActiveRecord::Migration
  def self.up
    create_table :qfds do |t|
      t.string :name
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :qfds
  end
end
