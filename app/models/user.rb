class User < ActiveRecord::Base
  acts_as_authentic

  has_many :qfds

  with_options(:class_name => "Invitation") do |i|
    i.has_many :invitations_sent, :foreign_key => "sender_id"
    i.has_many :invitations_received, :foreign_key => "recipient_id"
  end

  def role_symbols
    [:guest,]
  end

  # FIXME use declarative_authorization instead of voodoo
  def owns_rating?(rating)
    qfds.any? {|q| q.owns_rating?(rating)}
  end
end
