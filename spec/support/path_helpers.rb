module PathHelpers
  def be_the_practice_page
    eq(practice_path)
  end

  def be_the_welcome_page
    eq(page_path("welcome"))
  end
end
