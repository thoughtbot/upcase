require 'spec_helper'

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
    expect_page_to_have_title("Learn #{topic.name}")
  end

  scenario 'a topic has thoughtbot trail items listed separately' do
    fake_trail_map = FakeTrailMap.new(thoughtbot_resource: true)
    learn_trail = create(:trail, trail_map: fake_trail_map.trail)

    visit topic_path(learn_trail.topic)

    expect_to_have_learn_resource(fake_trail_map.resource_id)
  end

  scenario 'a topic has non-thoughtbot trail items listed under other resources' do
    fake_trail_map = FakeTrailMap.new
    learn_trail = create(:trail, trail_map: fake_trail_map.trail)

    visit topic_path(learn_trail.topic)

    expect_to_have_non_learn_resource(fake_trail_map.resource_id)
  end

  scenario "a topic lists the trail map's reference" do
    fake_trail_map = FakeTrailMap.new
    learn_trail = create(:trail, trail_map: fake_trail_map.trail)

    visit topic_path(learn_trail.topic)

    expect_to_have_reference(fake_trail_map.reference_id)
  end

  scenario "view a topic's related products" do
    topic = create(:topic, name: 'Topic 1')
    topic.workshops << create(:workshop, name: 'workshop 1')
    topic.products << create(:book, name: 'Book 1')
    topic.products << create(:screencast, name: 'Video 1')
    topic.products << create(:screencast, :inactive, name: 'Video Inactive')

    visit topic_path(topic)

    expect_to_see_related_workshop_named 'workshop 1'
    expect_to_see_related_book_named 'Book 1'
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
    topic.workshops << create(:workshop, name: 'Online Rails')

    visit topic_path(topic)

    expect_to_see_related_workshop_named('Online Rails')
  end

  def expect_to_see_related_workshop_named(workshop_name)
    within('aside .workshop') do
      expect(page).to have_content workshop_name
    end
  end

  def expect_to_see_related_book_named(book_name)
    within('aside .book') do
      expect(page).to have_content book_name
    end
  end

  def expect_to_see_related_video_named(video_name)
    within('aside .screencast') do
      expect(page).to have_content video_name
    end
  end

  def expect_to_not_see_related_item_named(name)
    within('aside') do
      expect(page).not_to have_content name
    end
  end

  def type_of_related_workshop_named(name)
    within '.related-products' do
      find('li', text: name).find('h4').text.strip
    end
  end

  def expect_to_have_learn_resource(resource_id)
    expect(page).
      to have_css("ul.learn .resource[data-id='#{resource_id}']")
    expect(page).
      not_to have_css("ul.other .resource[data-id='#{resource_id}']")
  end

  def expect_to_have_non_learn_resource(resource_id)
    expect(page).
      not_to have_css("ul.learn .resource[data-id='#{resource_id}']")
    expect(page).
      to have_css("ul.other .resource[data-id='#{resource_id}']")
  end

  def expect_to_have_reference(reference_id)
    expect(page).
      to have_css("ul.reference li[data-id='#{reference_id}']")
  end
end
