require 'spec_helper'

feature 'Learn about the Learn iOS app' do
  scenario 'A visitor sees a smart app banner on trails index and show' do
    topic = create(:topic, name: 'Git', featured: true)

    visit topics_path

    expect(page).to have_css("meta[name='apple-itunes-app']")
    expect(page.find("meta[name='apple-itunes-app']")["content"]).to(
      include topics_url
    )

    click_link "Git"

    expect(page).to have_css("meta[name='apple-itunes-app']")
    expect(page.find("meta[name='apple-itunes-app']")["content"]).to(
      include topic_url(topic)
    )

    visit root_path

    expect(page).not_to have_css("meta[name='apple-itunes-app']")
  end
end
