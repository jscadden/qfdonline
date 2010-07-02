module RegistrationHelpers

  def do_registration
    visit(register_path)
    fill_in("Email", :with => "example@example.com")
    fill_in("Password", :with => "password")
    fill_in("Password confirmation", :with => "password")
    click_button("Register")
  end
end

World(RegistrationHelpers)
