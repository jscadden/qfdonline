class User < ActiveRecord::Base
  acts_as_authentic

  has_many :qfds

  with_options(:class_name => "Invitation") do |i|
    i.has_many :invitations_sent, :foreign_key => "sender_id"
    i.has_many :invitations_received, :foreign_key => "recipient_id"
  end

  # FIXME we should probably get an actual name at some point
  def name
    "%s (%s)" % [login, email]
  end

  def role_symbols
    [:user,]
  end
end
