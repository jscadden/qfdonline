module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

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

    when /the QFD\'s page/
      qfd = Qfd.find(:first, :order => "updated_at DESC")
      qfd_path(qfd)

    when /the new QFD\'s page/
      qfd_path(assigns["qfd"])

    when /the new HOQ form/
      qfd = Qfd.find(:first, :order => "updated_at DESC")
      new_qfd_hoq_path(qfd)

    when /the new HOQ\'s page/
      qfd_hoq_path(assigns["qfd"], assigns["hoq"])

    when /the HOQ\'s page/
      qfd_hoq_path(@qfd, @hoq)

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
