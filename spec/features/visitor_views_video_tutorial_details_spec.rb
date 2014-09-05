require "rails_helper"

feature 'Visitor views video_tutorial details' do
  scenario 'views video_tutorial FAQs' do
    video_tutorial = create(:video_tutorial)
    video_tutorial_page = PageObjects::VideoTutorial.new(video_tutorial)
    create(:question, video_tutorial: video_tutorial, question: 'What color?', answer: 'Blue')
    create(:question, video_tutorial: video_tutorial, question: 'Pets allowed?', answer: 'No')

    video_tutorial_page.load

    expect(video_tutorial_page).to have_questions('What color?', 'Pets allowed?')
    expect(video_tutorial_page).to have_answers('Blue', 'No')
  end

  scenario 'sees no FAQ if it does not exist' do
    video_tutorial = create(:video_tutorial)
    video_tutorial_page = PageObjects::VideoTutorial.new(video_tutorial)

    video_tutorial_page.load

    expect(video_tutorial_page).to have_no_questions
    expect(video_tutorial_page).to have_no_answers
  end
end
