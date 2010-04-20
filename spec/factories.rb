Factory.define :user do |u|
  u.login "test"
  u.email "test@wagileconsulting.com"
  u.password "password"
  u.password_confirmation "password"
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
  u.login "hiding_rows_test"
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
  u.login "hiding_columns_test"
end

Factory.define "ratings_test_user", :parent => "hiding_rows_test_user" do |u|
  u.login "ratings_test"
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
  u.login "editing_weights_test"
end
