require "rails_helper"

describe "practice/show.html" do
  context "when a user has activity in trails" do
    it "doesn't show 'view completed' link when it has no completed trails" do
      stub_user_access

      render_show

      expect(rendered).not_to have_content("View completed trails")
    end
  end

  context "when a user has access to all features" do
    it "does not render the locked_features partial" do
      stub_user_access shows: true, trails: true

      render_show

      expect(rendered).not_to have_content("locked")
    end
  end

  context "when a user has access to shows" do
    it "renders locked features partial with correct features" do
      stub_user_access shows: true, trails: false

      render_show

      text = "Trails are locked"
      expect(rendered).to have_content(text)
    end
  end

  context "when a user does not have access to any features" do
    it "renders locked features partial with all features" do
      stub_user_access shows: false, trails: false

      render_show

      text = "Trails and shows are locked"
      expect(rendered).to have_content(text)
    end
  end

  context "for a non-admin user" do
    it "does not render the quiz links" do
      stub_user_access
      quiz = build_stubbed(:quiz)

      render_show quizzes: [quiz]

      expect(rendered).not_to have_content(quiz.title)
    end
  end

  def practice_stub(options = {})
    defaults = {
      shows: [],
      topics: [],
      in_progress_trails: [],
      unstarted_trails: [],
      just_finished_trails: [],
      quizzes: [],
      has_completed_trails?: false
    }
    double("Practice", defaults.merge(options))
  end

  def stub_user_access(features = {})
    view_stubs(:current_user).and_return(build_stubbed(:user))
    view_stubs(:current_user_has_active_subscription?).and_return(true)
    view_stubs(:current_user_has_access_to?).and_return(false)
    features.each do |feature, value|
      view_stubs(:current_user_has_access_to?).with(feature).and_return(value)
    end
  end

  def render_show(options = {})
    assign(:practice, practice_stub(options))
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
