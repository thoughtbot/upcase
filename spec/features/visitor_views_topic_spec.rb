require "rails_helper"

feature 'Topic pages' do
  scenario 'a visitor views the list of featured topics' do
    create(:topic, :featured, name: 'Topic 1')
    create(:topic, name: 'Topic 2')
    create(:topic, :featured, name: 'Topic 3')

    visit topics_path

    within('#topics-list') do
      expect(page).to have_content 'Topic 1'
      expect(page).to have_content 'Topic 3'
      expect(page).not_to have_content 'Topic 2'
    end
  end

  scenario 'a visitor navigates to a featured topic' do
    create(
      :topic,
      :featured,
      keywords: 'ruby, rails',
      summary: 'The first topic',
      name: 'Topic 1'
    )

    visit topics_path
    click_link 'Topic 1'

    within('.subject') do
      expect(page).to have_content 'Topic 1'
    end
  end

  scenario 'a topic page has relevant meta data' do
    topic = create(
      :topic,
      keywords: 'ruby, rails',
      summary: 'The first topic',
      name: 'Topic 1'
    )

    visit topic_path(topic)

    expect_page_to_have_meta_description(topic.summary)
    expect_page_to_have_meta_keywords(topic.keywords)
    expect_page_to_have_title("Upcase #{topic.name}")
  end

  scenario 'a topic has thoughtbot trail items listed separately' do
    fake_trail_map = FakeTrailMap.new(thoughtbot_resource: true)
    upcase_trail = create(:trail, trail_map: fake_trail_map.trail)

    visit topic_path(upcase_trail.topic)

    expect_to_have_upcase_resource(fake_trail_map.resource_id)
  end

  scenario 'a topic has non-thoughtbot trail items listed under other resources' do
    fake_trail_map = FakeTrailMap.new
    upcase_trail = create(:trail, trail_map: fake_trail_map.trail)

    visit topic_path(upcase_trail.topic)

    expect_to_have_non_upcase_resource(fake_trail_map.resource_id)
  end

  scenario "a topic lists the trail map's reference" do
    fake_trail_map = FakeTrailMap.new
    upcase_trail = create(:trail, trail_map: fake_trail_map.trail)

    visit topic_path(upcase_trail.topic)

    expect_to_have_reference(fake_trail_map.reference_id)
  end

  scenario "view a topic's related products" do
    topic = create(:topic, name: 'Topic 1')
    topic.video_tutorials << create(:video_tutorial, name: 'video_tutorial 1')
    topic.products << create(:video_tutorial, name: 'The Video 1')
    topic.products << create(:video_tutorial, :inactive, name: 'Video Inactive')

    visit topic_path(topic)

    expect_to_see_related_video_tutorial_named 'The Video 1 Video Tutorial'
    expect_to_see_related_video_named 'Video 1'
    expect_to_not_see_related_item_named 'Video Inactive'
  end

  scenario "A topic links to Giant Robots" do
    topic = create(:topic, name: 'Topic 1')

    visit topic_path(topic)

    expect(find_link("View related Topic 1 articles")[:href]).
      to eq "http://robots.thoughtbot.com/tags/#{topic.slug}"
  end

  scenario "view the type for a topic's related products" do
    topic = create(:topic, name: 'Rails')
    topic.video_tutorials << create(:video_tutorial, name: 'Online Rails')

    visit topic_path(topic)

    expect_to_see_related_video_tutorial_named('Online Rails')
  end

  def expect_to_see_related_video_tutorial_named(video_tutorial_name)
    within('aside .video_tutorial') do
      expect(page).to have_content video_tutorial_name
    end
  end

  def expect_to_see_related_video_named(video_name)
    within('aside .video_tutorial') do
      expect(page).to have_content video_name
    end
  end

  def expect_to_not_see_related_item_named(name)
    within('aside') do
      expect(page).not_to have_content name
    end
  end

  def type_of_related_video_tutorial_named(name)
    within '.related-products' do
      find('li', text: name).find('h4').text.strip
    end
  end

  def expect_to_have_upcase_resource(resource_id)
    expect(page).
      to have_css("ul.subscription .resource[data-id='#{resource_id}']")
    expect(page).
      not_to have_css("ul.other .resource[data-id='#{resource_id}']")
  end

  def expect_to_have_non_upcase_resource(resource_id)
    expect(page).
      not_to have_css("ul.subscription .resource[data-id='#{resource_id}']")
    expect(page).
      to have_css("ul.other .resource[data-id='#{resource_id}']")
  end

  def expect_to_have_reference(reference_id)
    expect(page).
      to have_css("ul.reference li[data-id='#{reference_id}']")
  end
end
