require 'spec_helper'

feature 'User views their timeline', js: true do
  scenario 'they see a list of their completed resources' do
    fake_trail_map = FakeTrailMap.new
    trail = create(:trail, trail_map: fake_trail_map.trail)
    completion = create(:completion, trail_object_id: fake_trail_map.resource_id)
    user = completion.user

    visit timeline_path(as: user)

    expect(page).to have_css '.timeline li', text: trail.name
    expect(page).to have_css '.timeline li', text: fake_trail_map.resource_title
  end

  scenario 'they see a list of their completed validations' do
    fake_trail_map = FakeTrailMap.new
    trail = create(:trail, trail_map: fake_trail_map.trail)
    completion = create(:completion, trail_object_id: fake_trail_map.validation_id)
    user = completion.user

    visit timeline_path(as: user)

    expect(page).to have_css '.timeline li', text: trail.name
    expect(page).to have_css '.timeline li', text: fake_trail_map.validation_title
  end
end
