require 'spec_helper'

feature 'User views their timeline', js: true do
  scenario 'they see a list of their completed resources' do
    trail = create(:trail, trail_map: FakeTrailMap.new.trail)
    completion = create(:completion, trail_object_id: fake_trail_map.resource_id)

    visit timeline_path(as: completion.user)

    expect(page).to have_css '.timeline li', text: trail.name
    expect(page).to have_css '.timeline li', text: fake_trail_map.resource_title
  end

  scenario 'they see a list of their completed validations' do
    trail = create(:trail, trail_map: FakeTrailMap.new.trail)
    completion = create(:completion, trail_object_id: fake_trail_map.validation_id)

    visit timeline_path(as: completion.user)

    expect(page).to have_css '.timeline li', text: trail.name
    expect(page).to have_css '.timeline li', text: fake_trail_map.validation_title
  end

  private

  def fake_trail_map
    @fake_trail_map ||= FakeTrailMap.new
  end
end
