require 'spec_helper'

feature 'User can see their trail map progress' do
  background do
    sign_in
  end

  scenario 'A user with nothing completed sees they have no progress', js: true do
    topic = create(:topic, name: 'Git', featured: true)
    trail = create(:trail, trail_map: trail_map, topic: topic)

    visit topics_path

    expect(page).to have_content "0/1 complete"
    expect(page).to have_css trail_node('Git', 1)
    expect(page).not_to have_css(".journey-bullet.complete")
  end

  scenario 'A user with items completed sees they have progress', js: true do
    resource_id = '2f720eaa8bcd602a7dc731feb224ff99bb85a03c'
    topic = create(:topic, name: 'Git', featured: true)
    trail = create(:trail, trail_map: trail_map, topic: topic)
    completion = @current_user.completions.create(
      trail_name: 'Git',
      trail_object_id: resource_id
    )

    visit topics_path

    expect(page).to have_content "1/1 complete"
    expect(page).to have_css(".trail-bullet.complete[data-id='#{resource_id}']")
  end

  scenario 'A user with items completed has the item checked', js: true do
    resource_id = '2f720eaa8bcd602a7dc731feb224ff99bb85a03c'
    topic = create(:topic, name: 'Git', featured: true)
    trail = create(:trail, trail_map: trail_map, topic: topic)
    completion = @current_user.completions.create(
      trail_name: 'Git',
      trail_object_id: resource_id
    )

    visit topic_path(topic)

    expect(find_field(resource_id)).to be_checked
  end

  scenario 'A user completes an item', js: true do
    resource_id = '2f720eaa8bcd602a7dc731feb224ff99bb85a03c'
    topic = create(:topic, name: 'Git', featured: true)
    trail = create(:trail, trail_map: trail_map, topic: topic)

    expect(@current_user.completions.where(trail_object_id: resource_id)).
      to be_empty

    visit topic_path(topic)

    check resource_id

    @current_user.reload
    expect(@current_user.completions.where(trail_object_id: resource_id)).
      not_to be_empty

    uncheck resource_id

    @current_user.reload
    expect(@current_user.completions.where(trail_object_id: resource_id)).
      to be_empty
  end

  def trail_map
    {
      'name' => "Git",
      'steps' => [
        {
          'name' => "Beginning Git",
          'resources' => [
            {
              'title' => "Try Git",
              'uri' => "http://try.github.com",
              'id' => "2f720eaa8bcd602a7dc731feb224ff99bb85a03c"
            }
          ]
        }
      ]
    }
  end

  def sign_in
    @current_user = create(:user)
    visit root_path(as: @current_user)
  end

  def trail_node(name, total)
    ".steps-complete[data-trail-name='#{name}'][data-total='#{total}']"
  end
end
