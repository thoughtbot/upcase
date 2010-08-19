module NavigationHelpers
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the sign up page/i
      sign_up_path
    when /the sign in page/i
      sign_in_path
    when /the password reset request page/i
      new_password_path

    # Add more page name => path mappings here

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end

  def link_to(link_description)
    case link_description
    when /the (.*) course/
      $1
    when /register for a section/
      'register-button'
    else
      raise %{Can't find a mapping from #{link_description.inspect} to a path: #{__FILE__}}
    end
  end
end

World(NavigationHelpers)
