class Invitation < ActiveRecord::Base
  belongs_to :qfd
  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"

  validates_uniqueness_of :token
  validates_uniqueness_of :recipient_email, :scope => :qfd_id, 
                          :message => "has already been invited"
  validates_presence_of :sender_id, :qfd_id
  validate :sender_must_own_qfd, :sender_must_not_be_recipient

  after_create :send_email

  named_scope :unaccepted, :conditions => {:recipient_id => nil}

  attr_accessor :url
  attr_accessible :recipient_email, :qfd_id

  delegate :name, :to => :sender, :prefix => true
  delegate :name, :to => :qfd, :prefix => true

  def initialize(*args)
    super(*args)
    generate_token
  end

  def to_param
    self.token
  end


  private

  def generate_token
    self.token = Digest::SHA1.hexdigest([rand, Time.now].join)
  end

  def send_email
    if url.blank?
      raise ArgumentError.new("I don't have a URL to send out")
    end

    InvitationMailer.deliver_invitation(recipient_email, url, 
                                        sender_name, qfd_name)
  end

  def sender_must_own_qfd
    unless qfd.user == sender
      errors.add(:qfd, "does not belong to you")
    end
  end

  def sender_must_not_be_recipient
    if self.sender == self.recipient
      errors.add(:recipient, "may not be the same as the sender")
    end
  end
end
