Spec::Matchers.define :be_permission_denied do 
  match do |actual|
    "403" == actual.code
  end
end
