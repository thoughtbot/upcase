require 'spec_helper'

feature 'User can visit trail maps from timeline' do
  scenario 'link is shown when there are no timeline items being displayed' do
    user = create(:user)

    visit timeline_path(as: user)

    expect(page).to have_link 'trail map', href: topics_path
  end

  scenario 'link is only shown on the first week' do
    trail = create(:trail, trail_map: fake_trail_map.trail)
    user = create(:user)
    create(:completion, :previous_week, user: user, trail_object_id: resource_id)
    most_recent_completion = create(:completion, :current_week, user: user, trail_object_id: validation_id)

    visit timeline_path(as: user)

    most_recent_week = week(most_recent_completion.created_at)
    expect(week_sections.count).to eq 2
    within_week most_recent_week do
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
    page.all 'a', text: 'trail map'
  end

  def week_sections
    page.all('.week')
  end

  def week(date)
    date.beginning_of_week.strftime("%b %-d")
  end

  def within_week(week, &block)
    within '.week', text: week do
      block.call
    end
  end
end

