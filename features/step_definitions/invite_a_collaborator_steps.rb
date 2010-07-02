Given /^an invitations_test user exists$/ do
  user = Factory.create("invitations_test_user")
  @qfd = user.qfds.first
  @hoq = @qfd.hoqs.first
end

Given /^an invited_test user exists$/ do
  user = Factory.create("invited_test_user")
end

Given /^I\'m on the qfds index$/ do
  visit(qfds_path)
end

Then /^I should see the invite a collaborator form$/ do
  page.should have_css("form#new_invitation")
end

When /^I fill in the invite a collaborator form$/ do
  visit(qfds_path)
  click_link("Invite A Collaborator")
  fill_in("Recipient email", :with => "example@example.com")
end

Then /^an invitation email should be sent$/ do
  unread_emails_for("example@example.com").size.should == 1
end

Then /^the invitation email should include an invitation link$/ do
  open_email("example@example.com")
  current_email.body.should match(/http:\/\/.+\/invitations\/[a-f0-9]{40}/)
end

Given /^an unaccepted invitation$/ do
  Given "I'm logged in as \"invitations_test\""
  click_link("Invite A Collaborator")
  fill_in("Recipient email", :with => "example@example.com")
  click_button("Invite")
  visit(logout_path)
end

Given /^an accepted invitation$/ do
  Given "an unaccepted invitation"
  Given "I'm logged in as \"invited_test\""
  visit(invitation_path(Invitation.last))
  click_button("Accept")
  visit(logout_path)
end

When /^I follow an invitation link$/ do
  visit(invitation_path(Invitation.last))
end

When /^I fill out the signup form$/ do
  fill_in("Email", :with => "invitee@example.com")
  fill_in("Password", :with => "password")
  fill_in("Password confirmation", :with => "password")
end

Then /^I should enter the debugger$/ do
  debugger
  x=1
end

Then /^I should see a collaboration invitation$/ do
  page.should have_css("form.edit_invitation")
  page.should have_css("input[type=submit][value='Accept']")
end


When /^I follow an invitation link and sign up as a new user$/ do
  When "I follow an invitation link"
  When "I follow \"Click here to register\""
  When "I fill out the signup form"
  When "I press \"Register\""
end

When /^I follow an invitation link and log in as "invited_test(?:@qfdonline\.com)?"$/ do
  When "I follow an invitation link"
  fill_in("Email", :with => "invited_test@qfdonline.com")
  fill_in("Password", :with => "password")
  click_button("Log in")
end

Then /^I should see a link to the invited qfd$/ do
  qfd = Qfd.find_by_name("Test QFD")
  page.should have_css("a[href^='#{qfd_path(qfd)}']")
end

When /^I follow the verification link in the verification email$/ do
  open_email("invitee@example.com")
  click_email_link_matching(/users\/verify/)
end
