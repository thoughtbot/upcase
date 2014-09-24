require "rails_helper"

describe "dashboards/show.html" do
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
        shows: true,
        video_tutorials: true,
        exercises: true
      )

      expect(rendered).not_to have_content("locked")
    end
  end

  context "when a user has access to shows and video tutorials" do
    it "renders locked features partial with exercises" do
      render_show shows: true, video_tutorials: true

      expect(rendered).to have_content("Exercises are locked")
    end
  end

  context "when a user has access to shows" do
    it "renders locked features partial with correct features" do
      render_show shows: true

      text = "Exercises and video tutorials are locked"
      expect(rendered).to have_content(text)
    end
  end

  context "when a user does not have access to any features" do
    it "renders locked features partial with all features" do
      render_show

      text = "Exercises, shows, and video tutorials are locked"
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
      shows: false,
      video_tutorials: false,
      exercises: false,
    }
  end
end
