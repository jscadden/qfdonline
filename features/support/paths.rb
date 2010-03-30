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

    when /^the HOQ\'s QFD$/i
      qfd_path(@hoq.qfd)

    when /^the requirement\'s HOQ$/i
      hoq_path(@requirement.hoq)

    when /^new HOQ form$/i
      new_hoq_path(:qfd_id => assigns["qfd"])

    when /^new (.*) form$/i
      send("new_#{$1.camelize.downcase}_path")

    when /^the new HOQ\'s page$/i
      hoq_path(assigns["hoq"])

    when /^the new (.*)\'s page$/i
      model_name = $1.camelize.downcase
      send("#{model_name}_path", assigns[model_name])

    when /^the (.*) index$/i
      send("#{$1.camelize.downcase.pluralize}_path")

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
