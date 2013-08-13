require 'spec_helper'

feature 'User views their timeline' do
  include Gravatarify::Helper

  scenario 'they see a list of their completed resources' do
    trail = create(:trail, trail_map: fake_trail_map.trail)
    completion = create(:completion, trail_object_id: fake_trail_map.resource_id)

    visit timeline_path(as: completion.user)

    expect(page).to have_css '.progress li', text: trail.name
    expect(page).to have_css '.progress li', text: fake_trail_map.resource_title
  end

  scenario 'they see a list of their completed validations' do
    trail = create(:trail, trail_map: fake_trail_map.trail)
    completion = create(:completion, trail_object_id: fake_trail_map.validation_id)

    visit timeline_path(as: completion.user)

    expect(page).to have_css '.progress li', text: trail.name
    expect(page).to have_css '.progress li', text: fake_trail_map.validation_title
  end

  scenario 'they see completed items grouped by week' do
    trail = create(:trail, trail_map: fake_trail_map.trail)
    resource_id = fake_trail_map.resource_id
    validation_id = fake_trail_map.validation_id
    completion = create(:completion, :beginning_of_august, trail_object_id: resource_id)
    create(:completion, :end_of_july, user: completion.user, trail_object_id: validation_id)

    visit timeline_path(as: completion.user)

    expect(page).to have_css '.week', text: 'Aug 5 - Aug 11'
    expect(page).to have_css '.week', text: 'Jul 29 - Aug 4'
  end

  scenario 'they see their bio' do
    user = create(:user, bio: 'All about me')

    visit timeline_path(as: user)

    expect(page).to have_css %{.profile img[src="#{gravatar_url(user)}"]}
    expect(page).to have_css '.user-info', text: user.name
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
