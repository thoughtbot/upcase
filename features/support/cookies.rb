module CookiesHelpers
  def cookies
    case Capybara.current_driver
    when :rack_test, :envjs
      rack_test_cookies
    end
  end

  def rack_test_cookies
    Capybara.
      current_session.
      driver.
      current_session.
      instance_variable_get("@rack_mock_session").
      cookie_jar
  end
end

World(CookiesHelpers)
