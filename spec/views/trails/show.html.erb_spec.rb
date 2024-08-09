require "rails_helper"

describe "trails/show.html.erb" do
  context "viewed by a visitor" do
    it "does not render the progress bar" do
      render_trail(signed_in: false)

      expect(rendered_content).not_to have_progress_bar
    end
  end

  context "viewed by a user" do
    it "renders the progress bar" do
      render_trail(signed_in: true)

      expect(rendered_content).to have_progress_bar
    end
  end

  def render_trail(signed_in:)
    assign(:trail, build_trail_with_steps)
    view_stubs(:signed_in?).and_return(signed_in)
    render template: "trails/show"
  end

  def have_progress_bar
    have_css ".trails-progress"
  end

  def rendered_content
    Capybara.string(rendered)
  end

  def build_trail_with_steps
    trail = create(:trail, topics: [create(:topic)])
    user = build_stubbed(:user)
    TrailWithProgress.new(
      trail,
      user: user,
      status_finder: StatusFinder.new(user: user)
    )
  end
end
