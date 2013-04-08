if Rails.env.production?
  ExceptionNotification::Notifier.exception_recipients = ["qfdwebsite@wagileconsulting.com"]
else
  ExceptionNotification::Notifier.exception_recipients = ["ewollesen@wagileconsulting.com"]
end

ExceptionNotification::Notifier.sender_address = "ewollesen@gmail.com"

ExceptionNotification::Notifier.email_prefix = "[QFD Error] "

