class InvitationMailer < ActionMailer::Base

  def invitation(recipient_email, url, sender_email, qfd_name)
    recipients recipient_email
    subject "Invitation to collaborate on my QFD"
    from "noreply@qfdonline.com"
    body :url => url, :sender_email => sender_email, :qfd_name => qfd_name
    sent_on Time.now
  end

end
