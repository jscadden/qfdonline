class Invitation < ActiveRecord::Base
  belongs_to :qfd
  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"

  validates_uniqueness_of :token
  validates_presence_of :sender_id, :qfd_id
  validate :sender_must_own_qfd

  before_create :generate_token
  after_create :send_email

  named_scope :unaccepted, :conditions => {:recipient_id => nil}

  attr_accessor :url
  attr_accessible :recipient_email, :qfd_id


  private

  def generate_token
    self.token = Digest::SHA1.hexdigest([rand, Time.now].join)
  end

  def send_email
    if self.url.blank?
      raise ArgumentError.new("I don't have a URL to send out")
    end

    InvitationMailer.deliver_invitation(self.recipient_email, self.url)
  end

  def sender_must_own_qfd
    unless qfd.user == sender
      Error.add(:qfd, "does not belong to you")
    end
  end
end
