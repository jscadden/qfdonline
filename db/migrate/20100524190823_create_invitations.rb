class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :sender_id
      t.string :recipient_email
      t.integer :recipient_id
      t.string :token
      t.integer :qfd_id

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
