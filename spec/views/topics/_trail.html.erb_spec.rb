require "rails_helper"

describe "topics/_trail.html" do
  context "with a just_finished trail" do
    it "renders as just_finished" do
      trail = stub_trail(complete: true, just_finished: true)

      render_trail trail

      expect(rendered).to have_content(trail.name)
      expect(rendered).to have_completed_text(trail)
    end
  end

  context "with a completed trail" do
    it "renders as completed trail" do
      trail = stub_trail(complete: true, just_finished: false)

      render_trail trail

      expect(rendered).to have_content(trail.name)
      expect(rendered).to have_completed_text(trail)
    end
  end

  context "with an unstarted trail" do
    it "renders as unstarted" do
      trail = stub_trail(
        complete: false,
        just_finished: false,
        unstarted: true,
        description: "**Markdown**"
      )

      render_trail trail

      expect(rendered).to have_selector(".unstarted")
      expect(rendered).to have_content(trail.name)
      expect(rendered).to match(/<strong>Markdown<\/strong>/)
      expect(rendered).not_to have_completed_text(trail)
    end
  end

  def stub_trail(complete:, just_finished:, unstarted: false, description: "")
    topic = build_stubbed(:topic, slug: "clean+code")
    stubbed_trail = build_stubbed(:trail, topics: [topic], description: description)
    stubbed_trail.tap do |trail|
      allow(trail).to receive(:complete?).and_return(complete)
      allow(trail).to receive(:just_finished?).and_return(just_finished)
      allow(trail).to receive(:unstarted?).and_return(unstarted)
      allow(trail).to receive(:steps_remaining).and_return(1)
    end
  end

  def render_trail(trail)
    view_stubs(:current_user).and_return(build_stubbed(:user))
    render "topics/trail", trail: trail
  end

  def have_completed_text(trail)
    have_content(trail.complete_text)
  end
end
