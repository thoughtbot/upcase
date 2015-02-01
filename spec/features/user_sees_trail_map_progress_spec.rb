require "rails_helper"

feature 'User can see their trail map progress' do
  background do
    sign_in
  end

  context "new trails" do
    scenario "A user with nothing completes sees they have no progress" do
      trail = create(:trail, :published, topic: topic)
      create(:step, trail: trail)

      visit trails_path

      expect(page).to have_content("1 step remaining")
    end

    scenario "A user with a completed trails sees their progress" do
      trail = create(:trail, :published, topic: topic, complete_text: "Done!")
      Status.create!(
        user: current_user,
        completeable: trail,
        state: Status::COMPLETE
      )

      visit trails_path

      expect(page).to have_content("Done!")
    end

    scenario "User does not see unpublished trails" do
      unpublished_trail = create(
        :trail,
        name: "This is an unpublished trail",
        published: false
      )
      create(:topic, featured: true, trails: [unpublished_trail])

      visit trails_path

      expect(page).not_to have_content("This is an unpublished trail")
    end
  end

  scenario 'A user with nothing completed sees they have no progress', js: true do
    create(:legacy_trail, trail_map: fake_trail_map.trail, topic: topic)

    visit trails_path

    expect(page).to have_content "0/1 complete"
    expect(page).to have_css trail_node('Git', 1)
    expect(page).not_to have_css(".journey-bullet.complete")
  end

  scenario 'A user with items completed sees they have progress', js: true do
    create(:legacy_trail, trail_map: fake_trail_map.trail, topic: topic)
    @current_user.completions.create(
      trail_name: 'Git',
      trail_object_id: fake_trail_map.validation_id
    )

    visit trails_path

    expect(page).to have_content "1/1 complete"
    expect(page).to have_css(".trail-bullet.complete[data-id='#{fake_trail_map.validation_id}']")
  end

  scenario 'A user does not see thoughtbot resources if they are not available' do
    create(:legacy_trail, trail_map: fake_trail_map.trail, topic: topic)

    visit topic_path(topic)
    expect(page).to_not have_content "Use these thoughtbot resources first"
  end

  scenario 'A user sees thoughtbot resources if they are available' do
    create(:legacy_trail, trail_map: fake_trail_map_with_thoughtbot_resource.trail, topic: topic)

    visit topic_path(topic)
    expect(page).to have_content "Use these thoughtbot resources first"
  end

  scenario 'A user with items completed has the item checked', js: true do
    create(:legacy_trail, trail_map: fake_trail_map.trail, topic: topic)
    @current_user.completions.create(
      trail_name: 'Git',
      trail_object_id: fake_trail_map.validation_id
    )

    visit topic_path(topic)

    expect(find_field(fake_trail_map.validation_id)).to be_checked
  end

  scenario 'A user completes an item', js: true do
    create(:legacy_trail, trail_map: fake_trail_map.trail, topic: topic)

    expect(@current_user.completions.where(trail_object_id: fake_trail_map.validation_id)).
      to be_empty

    visit topic_path(topic)

    find("[data-id='#{fake_trail_map.validation_id}'] .trail-bullet-hit-area").click

    @current_user.reload
    expect(@current_user.completions.where(trail_object_id: fake_trail_map.validation_id)).
      not_to be_empty

    find("[data-id='#{fake_trail_map.validation_id}'] .trail-bullet-hit-area").click

    @current_user.reload
    expect(@current_user.completions.where(trail_object_id: fake_trail_map.validation_id)).
      to be_empty
  end

  private

  def trail_node(name, total)
    ".steps-complete[data-trail-name='#{name}'][data-total='#{total}']"
  end

  def topic
    @topic ||= create(:topic, name: 'Git', featured: true)
  end

  def fake_trail_map
    @fake_trail_map ||= FakeTrailMap.new
  end

  def fake_trail_map_with_thoughtbot_resource
    @fake_trail_map_with_thoughtbot_resource ||= FakeTrailMap.new(thoughtbot_resource: true)
  end
end
