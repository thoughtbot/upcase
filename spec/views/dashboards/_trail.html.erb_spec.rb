require "rails_helper"

describe "dashboards/_trail.html" do
  context "with a complete trail" do
    it "renders as complete" do
      trail = stub_trail(complete: true)

      render_trail trail

      expect(rendered).to have_content(trail.name)
      expect(rendered).to have_complete(trail)
    end
  end

  context "with an incomplete trail" do
    it "renders as incomplete" do
      trail = stub_trail(complete: false)

      render_trail trail

      expect(rendered).to have_content(trail.name)
      expect(rendered).not_to have_complete(trail)
    end
  end

  def stub_trail(complete:, unstarted: false)
    build_stubbed(:trail).tap do |trail|
      Mocha::Configuration.allow(:stubbing_non_existent_method) do
        trail.stubs(:unstarted?).returns(unstarted)
        trail.stubs(:complete?).returns(complete)
      end
    end
  end

  def render_trail(trail)
    view_stubs(:current_user).returns(build_stubbed(:user))
    render "dashboards/trail", trail: trail
  end

  def have_complete(trail)
    have_content(trail.complete_text)
  end
end
