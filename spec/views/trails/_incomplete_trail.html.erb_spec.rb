require "rails_helper"

describe "trails/_incomplete_trail.html" do
  context "for a trail with only videos" do
    it "renders a CTA link" do
      view_stubs(:current_user).and_return(Guest.new)
      video = create(:video)

      render_trail completeables: [video]

      expect(rendered).to have_cta_link
    end
  end

  context "for an empty trail" do
    it "doesn't render a CTA link" do
      render_trail completeables: []

      expect(rendered).not_to have_cta_link
    end
  end

  def render_trail(...)
    view_stubs(:current_user_has_access_to?).and_return(true)

    render "trails/incomplete_trail", trail: create_trail(...)
  end

  def create_trail(completeables:)
    trail = create(:trail)
    user = build_stubbed(:user)

    completeables.each do |completeable|
      create(:step, completeable: completeable, trail: trail)
    end

    TrailWithProgress.new(
      trail,
      user: user,
      status_finder: StatusFinder.new(user: user),
    )
  end

  def have_cta_link
    have_css(".cta-button")
  end
end
