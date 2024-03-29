Factory.sequence "email" do |n|
  "test_user#{n}@qfdonline.com"
end

Factory.define :user do |u|
  u.email {Factory.next("email")}
  u.password "password"
  u.password_confirmation "password"
  u.verified_at Time.now
end

Factory.define "qfd" do |d|
  d.name "Test QFD"
end

Factory.define "hoq" do |h|
  h.name "Test HOQ"
end

Factory.define "hoq_list" do |l|
end

Factory.sequence "requirement_name" do |n|
  "Test Requirement #{n}"
end

Factory.define "requirement" do |r|
  r.name {Factory.next("requirement_name")}
end

Factory.define "rating" do |r|
  r.value 3
end

Factory.define "hiding_rows_test_user", :parent => "user" do |u|
  u.email "hiding_rows_test@qfdonline.com"
  u.after_build do |u|
    qfd = Factory.create("qfd", :user => u)
    2.times do |x|
      hoq = Factory.create("hoq")
      qfd.hoq_list.insert_back(hoq)

      if x.zero?
        2.times do |y|
          req = Factory.build("requirement", :weight => rand(100))
          hoq.primary_requirements_list.requirements << req
        end
      end

      2.times do |z|
        req = Factory.build("requirement", :weight => rand(100))
        hoq.secondary_requirements_list.requirements << req
      end
    end
  end
end

Factory.define "hiding_columns_test_user", :parent => "hiding_rows_test_user" do |u|
  u.email "hiding_columns_test@qfdonline.com"
end

Factory.define "ratings_test_user", :parent => "hiding_rows_test_user" do |u|
  u.email "ratings_test@qfdonline.com"
  u.after_create do |u|
    qfd = u.qfds.first
    hoq = qfd.hoq_list.first

    # just create one rating for testing purposes
    Rating.create!(:primary_requirement => hoq.primary_requirements.first,
                   :secondary_requirement => hoq.secondary_requirements.first,
                   :value => 3)
  end
end

Factory.define "editing_weights_user", :parent => "ratings_test_user" do |u|
  u.email "editing_weights_test@qfdonline.com"
end

Factory.define "invitations_test_user", :parent => "user" do |u|
  u.email "invitations_test@qfdonline.com"
  u.after_create do |u|
    u.qfds.create!(:name => "Test QFD")
  end
end

Factory.define "invited_test_user", :parent => "user" do |u|
  u.email "invited_test@qfdonline.com"
end

Factory.define "invitation" do |i|
  i.association :sender, :factory => :user
  i.qfd {|i| i.association(:qfd, :user => i.sender)}
  i.recipient_email {Factory.next("email")}
  i.url {|i| "http://www.example.com/invitations/#{i.token}"}
end

Factory.define "unaccepted_invitation", :parent => "invitation" do |i|
end

Factory.define "collab_test_user", :parent => "user" do |u|
  u.email "collab_test@qfdonline.com"
end

Factory.define "unverified_user", :parent => "user" do |u|
  u.verified_at nil
end
