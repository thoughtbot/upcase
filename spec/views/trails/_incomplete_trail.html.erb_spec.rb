require "rails_helper"

describe "trails/_incomplete_trail.html" do
  context "for a trail with only videos" do
    it "renders a Start Trail link" do
      render_trail completeables: [build_stubbed(:video)]

      expect(rendered).to have_start_trail_link
    end
  end

  context "for a trail with only exercises" do
    it "renders a Start Trail link" do
      render_trail completeables: [build_stubbed(:exercise)]

      expect(rendered).to have_start_trail_link
    end
  end

  context "for an empty trail" do
    it "doesn't render a Start Trail link" do
      render_trail completeables: []

      expect(rendered).not_to have_start_trail_link
    end
  end

  def render_trail(*trail_args)
    view_stubs(:current_user_has_access_to?).and_return(true)

    render "trails/incomplete_trail", trail: build_trail(*trail_args)
  end

  def build_trail(completeables:)
    steps = completeables.map do |completeable|
      build_stubbed(:step, completeable: completeable)
    end

    TrailWithProgress.new(
      build_stubbed(:trail, steps: steps),
      user: build_stubbed(:user)
    )
  end

  def have_start_trail_link
    have_link("Start trail")
  end
end
