require 'spec_helper'

feature 'Visitor views workshop details' do
  scenario 'views workshop FAQs' do
    workshop = create(:workshop)
    workshop_page = PageObjects::Workshop.new(workshop)
    create(:question, workshop: workshop, question: 'What color?', answer: 'Blue')
    create(:question, workshop: workshop, question: 'Pets allowed?', answer: 'No')

    workshop_page.load

    expect(workshop_page).to have_questions('What color?', 'Pets allowed?')
    expect(workshop_page).to have_answers('Blue', 'No')
  end

  scenario 'sees no FAQ if it does not exist' do
    workshop = create(:workshop)
    workshop_page = PageObjects::Workshop.new(workshop)

    workshop_page.load

    expect(workshop_page.size).to eq 0
    expect(workshop_page.size).to eq 0
  end
end
