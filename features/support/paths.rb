module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    when /the login(?: page)?/
      login_path

    when /the logout(?: page)?/
      logout_path

    when /the root page/
      root_path

    when /the QFDs index/
      qfds_path

    when /the new QFD\'s page/
      qfd_path(assigns["qfd"])

    when /the new HOQ form/
      new_qfd_hoq_path(@qfd)

    when /the new HOQ\'s page/
      qfd_hoq_path(assigns["qfd"], assigns["hoq"])

    when /the HOQ\'s page/
      qfd_hoq_path(@qfd, @hoq)

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
