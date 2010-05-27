class InvitationMailer < ActionMailer::Base

  def invitation(recipient_email, access_url)
    recipients recipient_email
    subject "Invitation to collaborate on my QFD"
    from "invitations@qfdonline.com"
    body :access_url => access_url
  end

end
