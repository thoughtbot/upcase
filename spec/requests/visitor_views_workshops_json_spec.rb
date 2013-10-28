require 'spec_helper'

feature 'Visitor views workshops json' do
  include WorkshopsHelper

  scenario 'receives JSON for an active workshop' do
    active_workshop = create(:workshop, :active)
    inactive_workshop = create(:workshop, :inactive)

    visit workshops_path(format: :json)
    workshops_json = json_in(page.source)

    expect(workshops_json).to eq json_for(active_workshop)
  end

  scenario 'receives JSON, with the desired callback, for an active workshop' do
    active_workshop = create(:workshop, :active)
    inactive_workshop = create(:workshop, :inactive)

    visit workshops_path(format: :json, callback: callback)
    workshops_json = json_in(page_source_with_callback)

    expect(workshops_json).to eq json_for(active_workshop)
  end

  def callback
    'foo_bar_callback'
  end

  def page_source_with_callback
    matcher = /#{callback}\(([^\)]+)\)/
    matches = matcher.match(page.source)
    matches[1]
  end

  def json_in(page)
    JSON.parse(page)
  end

  def json_for(workshop)
    JSON.parse(workshops_json [workshop])
  end
end
