require "rails_helper"

describe "practice/show.html" do
  context "when a user has activity in trails" do
    it "doesn't show 'view completed' link when it has no completed trails" do
      render_show

      expect(rendered).not_to have_content("View completed trails")
    end

    it "shows 'View completed trails' link when it has completed trails" do
      render_show(has_completed_trails: true)

      expect(rendered).to have_content("View all completed trails")
    end
  end

  context "when a user has access to all features" do
    it "does not render the locked_features partial" do
      render_show shows: true, trails: true

      expect(rendered).not_to have_content("locked")
    end
  end

  context "when a user has access to shows" do
    it "renders locked features partial with correct features" do
      render_show shows: true, trails: false

      text = "Trails are locked"
      expect(rendered).to have_content(text)
    end
  end

  context "when a user does not have access to any features" do
    it "renders locked features partial with all features" do
      render_show shows: false, trails: false

      text = "Trails and shows are locked"
      expect(rendered).to have_content(text)
    end
  end

  def render_show(options = {})
    options = default_options.merge(options)
    completed = options[:has_completed_trails]
    assign(
      :practice,
      double(
        "Practice",
        shows: [],
        topics: [],
        in_progress_trails: [],
        unstarted_trails: [],
        just_finished_trails: [],
        has_completed_trails?: completed
      )
    )
    view_stubs(:current_user).and_return(build_stubbed(:user))
    view_stubs(:current_user_has_active_subscription?).and_return(true)
    options.each do |feature, value|
      view_stubs(:current_user_has_access_to?).with(feature).and_return(value)
    end
    render template: "practice/show"
  end

  def default_options
    {
      repositories: false,
      forum: false,
      shows: false,
      trails: false
    }
  end
end
