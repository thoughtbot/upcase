require "rails_helper"

describe "products/_exercises.html", type: :view do
  it "renders links to exercises for users with access" do
    view_stubs(:current_user_has_access_to?).with(:exercises).returns(true)

    render "products/exercises"

    expect(rendered).
      to have_css("a[href='https://exercises.upcase.com/exercises/1']")
  end

  it "does not render links to exercises for users without access" do
    view_stubs(:current_user_has_access_to?).with(:exercises).returns(false)

    render "products/exercises"

    expect(rendered).not_to have_css("a[href]")
  end
end
