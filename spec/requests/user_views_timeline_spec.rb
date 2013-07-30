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

  scenario 'they see a  link directing them to complete trail maps' do
    trail = create(:trail, trail_map: FakeTrailMap.new.trail)
    completion = create(:completion, trail_object_id: fake_trail_map.validation_id)

    visit timeline_path(as: completion.user)

    expect(page).to have_link 'trail map', href: topics_path
  end

  scenario 'they see their bio' do
    user = create(:user, bio: 'All about me')

    visit timeline_path(as: user)

    expect(page).to have_role 'user-bio', text: 'All about me'
  end

  scenario 'they see a placeholder bio when none is present' do
    user = create(:user, bio: nil)

    visit timeline_path(as: user)

    expect(page).to have_role 'user-bio', text: 'Tell us about yourself'
  end

  private

  def fake_trail_map
    @fake_trail_map ||= FakeTrailMap.new
  end
end
