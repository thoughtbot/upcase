require "rails_helper"

describe "practice/show.html" do
  context "when a user has activity in trails" do
    it "doesn't show 'view completed' link when it has no completed trails" do
      render_show

      expect(rendered).not_to have_content("View completed trails")
    end

    it "shows 'View completed trails' link when it has completed trails" do
      render_show(has_completed_trails: true)

      expect(rendered).to have_content("View completed trails")
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
    completed = options[:has_completed_trails]
    assign(
      :practice,
      stub(shows: [], topics: [], trails: [], has_completed_trails?: completed)
    )
    view_stubs(:current_user).returns(build_stubbed(:user))
    view_stubs(:current_user_has_active_subscription?).returns(true)
    options.each do |feature, value|
      view_stubs(:current_user_has_access_to?).with(feature).returns(value)
    end
    render template: "practice/show"
  end

  def default_options
    {
      repositories: false,
      forum: false,
      shows: false,
      video_tutorials: false,
      exercises: false,
    }
  end
end
