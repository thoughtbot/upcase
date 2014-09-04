require "rails_helper"

describe "dashboards/show.html" do
  ENV["UPCASE_REPO_URL"] = "upcase_repo_url"

  context "when a user does not have access to the upcase repo" do
    it "renders without a link to upcase repo" do
      render_show

      expect(rendered).
        not_to have_css("a[href='upcase_repo_url']")
      expect(rendered).to have_css("a[href='#{edit_subscription_path}']")
    end
  end

  context "when a user has access to the upcase repo" do
    it "renders with a link to upcase repo" do
      render_show source_code: true

      expect(rendered).
        to have_css("a[href='upcase_repo_url']")
    end
  end

  context "when a user does not have access to upcase live" do
    it "renders without a link to upcase live" do
      render_show

      expect(rendered).not_to have_css("a[href='#{OfficeHours.url}']")
      expect(rendered).to have_css("a[href='#{edit_subscription_path}']")
    end
  end

  context "when a user has access to upcase live" do
    it "renders with a link to upcase live" do
      render_show office_hours: true

      expect(rendered).to have_css("a[href='#{OfficeHours.url}']")
    end
  end

  context "when a user has access to all features" do
    it "does not render the locked_features partial" do
      render_show(
        books: true,
        shows: true,
        workshops: true,
        exercises: true,
        screencasts: true
      )

      expect(rendered).not_to have_content("locked")
    end
  end

  context "when a user has access to shows and workshops" do
    it "renders locked features partial with exercises and books" do
      render_show shows: true, workshops: true, screencasts: true

      expect(rendered).to have_content("Books and exercises are locked")
    end
  end

  context "when a user has access to shows" do
    it "renders locked features partial with correct features" do
      render_show shows: true

      text = "Books, exercises, screencasts, and workshops are locked"
      expect(rendered).to have_content(text)
    end
  end

  context "when a user does not have access to any features" do
    it "renders locked features partial with all features" do
      render_show

      text = "Books, exercises, screencasts, shows, and workshops are locked"
      expect(rendered).to have_content(text)
    end
  end

  def render_show(options = {})
    options = default_options.merge(options)
    assign(:dashboard, stub(shows: [], topics: []))
    view_stubs(:current_user).returns(build_stubbed(:user))
    view_stubs(:current_user_has_active_subscription?).returns(true)
    options.each do |feature, value|
      view_stubs(:current_user_has_access_to?).with(feature).returns(value)
    end
    render template: "dashboards/show"
  end

  def default_options
    {
      source_code: false,
      office_hours: false,
      forum: false,
      screencasts: false,
      shows: false,
      workshops: false,
      exercises: false,
      books: false
    }
  end

  def include_exercises
    have_content("Hone your skills")
  end

  def include_workshops
    have_content("Enroll in our online workshops")
  end

  def include_screencasts_and_shows
    have_content("Watch our web shows and screencasts")
  end

  def include_shows
    have_content("Watch The Weekly Iteration")
  end

  def include_books
    have_content("Read our eBooks")
  end
end
