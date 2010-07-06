# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

if ENV["GMAIL_SMTP_USER"].blank? || ENV["GMAIL_SMTP_PASSWORD"].blank?
  $stderr.puts("DON'T FORGET TO SET THE GMAIL_SMTP_USER/PASSWORD")
end

user = nil
if Rails.env.production?
  user = User.create!(:email => "user@qfdonline.com",
                      :verified_at => Time.now,
                      :password => "password",
                      :password_confirmation => "password")
else
  user = User.create!(:email => "ericw+qfdonline-user@xmtp.net",
                      :verified_at => Time.now,
                      :password => "password",
                      :password_confirmation => "password")
end
Authorization::current_user = user

qfd = user.qfds.create!(:name => "Test QFD")

public_qfd = user.qfds.create!(:name => "Public QFD", :public => true)
