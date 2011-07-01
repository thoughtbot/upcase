module JavascriptHelpers
  def using_javascript_driver?
    Capybara.current_driver == Capybara.javascript_driver
  end
end

World(JavascriptHelpers)
