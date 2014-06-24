require "spec_helper"

describe "dashboards/show.html" do
  ENV["LEARN_REPO_URL"] = "learn_repo_url"

  context "when a user does not have access to the learn repo" do
    it "renders without a link to learn repo" do
      render_show

      expect(rendered).
        not_to have_css("a[href='learn_repo_url']")
      expect(rendered).to have_css("a[href='#{edit_subscription_path}']")
    end
  end

  context "when a user has access to the learn repo" do
    it "renders with a link to learn repo" do
      render_show source_code: true

      expect(rendered).
        to have_css("a[href='learn_repo_url']")
    end
  end

  context "when a user does not have access to learn live" do
    it "renders without a link to learn live" do
      render_show

      expect(rendered).not_to have_css("a[href='#{OfficeHours.url}']")
      expect(rendered).to have_css("a[href='#{edit_subscription_path}']")
    end
  end

  context "when a user has access to learn live" do
    it "renders with a link to learn live" do
      render_show office_hours: true

      expect(rendered).to have_css("a[href='#{OfficeHours.url}']")
    end
  end

  context "when a user has access to exercises, workshops, and shows" do
    it "renders with access to exercises, workshops and shows" do
      render_show shows: true, workshops: true, exercises: true

      expect(rendered).not_to have_content("locked")
    end
  end

  context "when a user has access to shows and workshops" do
    it "renders with access to shows but without access to workshops" do
      render_show shows: true, workshops: true

      expect(rendered).to have_content("Exercises are locked")
    end
  end

  context "when a user has access to shows" do
    it "renders with access to shows but without access to workshops" do
      render_show shows: true

      expect(rendered).
        to have_content("Exercises and video tutorials are locked")
    end
  end

  context "when a user does not have access to shows" do
    it "renders without access to shows, workshops, and exercises" do
      render_show

      expect(rendered).
        to have_content("Exercises, video tutorials, and shows are locked")
    end
  end

  def render_show(options = {})
    options = default_options.merge(options)
    view_stubs(:current_user).returns(build_stubbed(:user))
    options.each do |feature, value|
      view_stubs(:current_user_has_access_to?).with(feature).returns(value)
    end
    view_stubs(:current_user_has_access_to_shows?).
      returns(options[:shows])
    assign :catalog, Catalog.new
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
      exercises: false
    }
  end
end
