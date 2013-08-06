require 'spec_helper'

feature 'User can visit trail maps from timeline' do
  scenario 'link is shown when there are no timeline items being displayed' do
    user = create(:user)

    visit timeline_path(as: user)

    expect(page).to have_link 'trail map', href: topics_path
  end

  scenario 'link is only shown on the first week' do
    trail = create(:trail, trail_map: fake_trail_map.trail)
    completion = create(:completion, :beginning_of_august, trail_object_id: validation_id)
    create(:completion, :end_of_july, user: completion.user, trail_object_id: resource_id)

    visit timeline_path(as: completion.user)

    expect(week_sections.count).to eq 2
    within_first_week do
      expect(trail_map_links.count).to eq 1
    end
  end

  private

  def fake_trail_map
    @fake_trail_map ||= FakeTrailMap.new
  end

  def resource_id
    fake_trail_map.resource_id
  end

  def validation_id
    fake_trail_map.validation_id
  end

  def trail_map_links
    page.all 'a', text: 'trail map', href: topics_path
  end

  def week_sections
    page.all('.week')
  end

  def within_first_week(&code)
    within '.week', text: 'Jul 29 - Aug 4' do
      code.call
    end
  end
end

