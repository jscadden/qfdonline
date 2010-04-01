# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)


user = User.create!(:login => "ericw",
                    :email => "ericw@e3labs.com",
                    :password => "password",
                    :password_confirmation => "password")

qfd = user.qfds.create!(:name => "Test QFD")

3.times do |x|
  hoq = qfd.hoqs.create!(:name => "Test HOQ ##{x}")

  if x.zero?
    3.times do |y|
      req = hoq.primary_requirements.create!(:name => "Test Requirement ##{Requirement.count}")
    end
  end

  3.times do |z|
    req = hoq.secondary_requirements.create!(:name => "Test Requirement ##{Requirement.count}")
  end
end
