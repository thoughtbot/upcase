require "rails_helper"

describe "exercises/_exercise_for_trail_preview.html" do
  context "without access to exercises" do
    it "renders an upgrade link" do
      stub_access(trails: false)
      stub_current_user

      render_exercise

      expect(rendered).to have_upgrade_link
    end
  end

  context "with access to exercises" do
    it "doesn't render an upgrade link" do
      stub_access(trails: true)
      stub_current_user

      render_exercise

      expect(rendered).not_to have_upgrade_link
    end
  end

  def stub_access(features)
    features.each do |name, access|
      view_stubs(:current_user_has_access_to?).with(name).and_return(access)
    end
  end

  def stub_current_user
    view_stubs(:current_user).and_return(build_stubbed(:user))
  end

  def render_exercise
    exercise = CompleteableWithProgress.
      new(build_stubbed(:exercise), "Not Started")
    render "exercises/exercise_for_trail_preview", exercise: exercise
  end

  def have_upgrade_link
    have_css("a.upgrade-link")
  end
end
