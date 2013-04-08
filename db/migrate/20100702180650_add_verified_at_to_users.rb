class AddVerifiedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :verified_at, :datetime, :default => nil
  end

  def self.down
    drop_column :users, :verified_at
  end
end
