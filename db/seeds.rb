# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)


user = User.create!(:login => "user",
                    :email => "user@qfdonline.com",
                    :password => "password",
                    :password_confirmation => "password")

qfd = user.qfds.create!(:name => "Test QFD")

3.times do |x|
  hoq = Hoq.new(:name => "Test HOQ ##{x}")
  qfd.hoq_list.insert_back(hoq)

  if x.zero?
    3.times do |y|
      req = Requirement.new(:name => "Test Requirement ##{Requirement.count}",
                            :weight => rand(100))
      hoq.primary_requirements_list.requirements << req
    end
  end

  3.times do |z|
      req = Requirement.new(:name => "Test Requirement ##{Requirement.count}",
                            :weight => rand(100))
      hoq.secondary_requirements_list.requirements << req
  end

  hoq.primary_requirements.each do |pri_req|
    hoq.secondary_requirements.each do |sec_req|
      rating = Rating.lookup(pri_req, sec_req)
      if rating.nil?
        Rating.create!(:primary_requirement => pri_req,
                       :secondary_requirement => sec_req,
                       :value => [1, 3, 9, nil].rand)
      end
    end
  end
end
