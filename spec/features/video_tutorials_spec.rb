require "rails_helper"

describe 'VideoTutorials' do
  it 'displays their formatted resources' do
    user = create(:user, :with_full_subscription)
    video_tutorial = create(:video_tutorial, resources: "* Item 1\n*Item 2")
    create(:video, watchable: video_tutorial)

    visit video_tutorial_path(video_tutorial, as: user)

    expect(page).to have_css('.resources li', text: 'Item 1')
  end
end
