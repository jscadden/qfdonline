class InvitationMailer < ActionMailer::Base

  def invitation(recipient_email, url)
    recipients recipient_email
    subject "Invitation to collaborate on my QFD"
    from "invitations@qfdonline.com"
    body :url => url
    sent_on Time.now
  end

end
