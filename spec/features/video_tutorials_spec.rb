require "rails_helper"

describe 'VideoTutorials' do
  it 'displays their formatted resources' do
    user = create(:user)
    video_tutorial = create(:video_tutorial, resources: "* Item 1\n*Item 2")
    create(:video, watchable: video_tutorial)
    license = create_license_from_licenseable(video_tutorial, user)

    visit video_tutorial_path(video_tutorial, as: user)

    expect(page).to have_css('.resources li', text: 'Item 1')
  end

  it 'lists office hours' do
    user = create(:user)
    video_tutorial = create(:video_tutorial)
    create(:video, watchable: video_tutorial)
    license = create_license_from_licenseable(video_tutorial, user)

    visit video_tutorial_path(video_tutorial, as: user)

    expect(page).to have_css('.office-hours', text: OfficeHours.time)
  end
end
