class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :qfds do |t|
      t.string :name, :null => false
      t.references :user

      t.timestamps
    end

    create_table :hoqs do |t|
      t.string :name, :null => false
      t.references :qfd
      t.references :hoq

      t.timestamps
    end

    create_table :requirements do |t|
      t.string :name, :null => false
      t.references :hoq

      t.timestamps
    end
  end

  def self.down
    drop_table :qfds
    drop_table :hoqs
    drop_table :requirements
  end
end
