Factory.define :user do |u|
  u.login "test"
  u.email "test@wagileconsulting.com"
  u.password "foobar"
  u.password_confirmation "foobar"
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
  r.name Factory.next("requirement_name")
end
