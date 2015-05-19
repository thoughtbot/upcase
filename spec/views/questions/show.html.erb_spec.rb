require "rails_helper"

describe "questions/show.html" do
  it "renders the prompt as markdown" do
    render_question(prompt: "Hey **you** guys")

    expect(rendered_content).to have_content("Hey you guys")
    expect(rendered_content).to have_css("strong", text: "you")
  end

  it "displays a title that includes the position" do
    render_question(position: 4)

    expect(rendered_content).to have_content("Question 4")
  end

  def render_question(attributes)
    build_stubbed(:question, attributes).tap do |question|
      assign(:question, question)
      assign(:quiz, question.quiz)
      render template: "questions/show"
    end
  end

  def rendered_content
    Capybara.string(rendered)
  end
end
