class User < ActiveRecord::Base
  acts_as_authentic do
    validate_email_field(true)
    validate_password_field(true)
  end

  has_many :qfds

  with_options(:class_name => "Invitation") do |i|
    i.has_many :invitations_sent, :foreign_key => "sender_id"
    i.has_many :invitations_received, :foreign_key => "recipient_id"
  end

  def name
    email
  end

  def role_symbols
    [:user,]
  end

  def send_verification_email
    if verified_at.nil?
      reset_perishable_token!
      UserMailer.deliver_verification(self)
    end
  end

  def verify!
    reset_perishable_token
    self.update_attributes!(:verified_at => Time.now)
  end

  def active?
    !verified_at.nil?
  end
  alias_method :verified?, :active?
end
