require "rails_helper"

RSpec.describe "flashcards/show.html" do
  it "renders the prompt as markdown" do
    render_flashcard(prompt: "Hey **you** guys")

    expect(rendered_content).to have_content("Hey you guys")
    expect(rendered_content).to have_css("strong", text: "you")
  end

  it "displays a title that includes the position" do
    render_flashcard(position: 4)

    expect(rendered_content).to have_content("Flashcard 4")
  end

  def render_flashcard(attributes)
    build_stubbed(:flashcard, attributes).tap do |flashcard|
      assign(:flashcard, flashcard)
      assign(:deck, flashcard.deck)
      render template: "flashcards/show"
    end
  end

  def rendered_content
    Capybara.string(rendered.to_s)
  end
end
