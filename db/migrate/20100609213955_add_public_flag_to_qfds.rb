class AddPublicFlagToQfds < ActiveRecord::Migration
  def self.up
    add_column :qfds, :public, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :qfds, :public
  end
end
