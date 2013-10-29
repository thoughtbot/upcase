require 'spec_helper'

describe 'workshops/show.html.erb' do
  include Capybara::DSL

  it 'includes workshop FAQs' do
    workshop = create(:workshop)
    create(:question, workshop: workshop, question: 'What color?', answer: 'Blue')
    create(:question, workshop: workshop, question: 'Pets allowed?', answer: 'No')

    assign(:workshop, workshop)
    assign(:offering, workshop)
    render template: 'workshops/show', workshop: workshop

    expect(rendered).to include('What color?')
    expect(rendered).to include('Pets allowed?')
    expect(rendered).to include('Blue')
    expect(rendered).to include('No')
  end
end
