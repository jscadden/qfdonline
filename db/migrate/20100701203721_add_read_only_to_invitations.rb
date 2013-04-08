class AddReadOnlyToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :read_only, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :invitations, :read_only
  end
end
