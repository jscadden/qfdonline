class UserMailer < ActionMailer::Base
  
  def verification(user)
    subject "Please verify your QFDOnline Registration"
    recipients user.email
    from "noreply@qfdonline.com"
    sent_on Time.now
    body :user => user
  end

end
