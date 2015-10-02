require "rails_helper"

describe "exercises/_exercise_for_trail_preview.html" do
  context "without an active subscription" do
    it "renders an upgrade link" do
      stub_has_active_subscription(false)

      render_exercise

      expect(rendered).to have_upgrade_link
    end

    it "does not render a link a to the exercise" do
      stub_has_active_subscription(false)

      render_exercise

      expect(rendered).not_to have_exercise_link
    end
  end

  context "with an active subscription" do
    it "doesn't render an upgrade link" do
      stub_has_active_subscription(true)

      render_exercise

      expect(rendered).not_to have_upgrade_link
    end

    it "does not render a link a to the exercise" do
      stub_has_active_subscription(true)

      render_exercise

      expect(rendered).to have_exercise_link
    end
  end

  def stub_has_active_subscription(access)
    stub_signed_in
    view_stubs(:current_user_has_active_subscription?).and_return(access)
  end

  def stub_signed_in
    view_stubs(:signed_in?).and_return(true)
  end

  def render_exercise
    exercise = CompleteableWithProgress.
      new(build_stubbed(:exercise), "Not Started")
    render "exercises/exercise_for_trail_preview", exercise: exercise
  end

  def have_upgrade_link
    have_css("a.upgrade-link")
  end

  def have_exercise_link
    have_css("a.exercise-item")
  end
end
