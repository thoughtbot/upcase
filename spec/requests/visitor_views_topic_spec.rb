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

  scenario 'a topic has thoughtbot trail items highlighted' do
    fake_trail_map = FakeTrailMap.new
    fake_trail_map.resource_uri = 'http://learn.thoughtbot.com/workshops/1'
    learn_trail = create(:trail, trail_map: fake_trail_map.trail)
    other_trail = create(:trail, trail_map: FakeTrailMap.new.trail)

    visit topic_path(learn_trail.topic)

    expect_to_have_learn_resource_highlight(fake_trail_map.resource_id)

    visit topic_path(other_trail.topic)

    expect_not_to_have_learn_resource_highlight(fake_trail_map.resource_id)
  end

  scenario "view a topic's related products" do
    topic = create(:topic, name: 'Topic 1')
    topic.workshops << create(:workshop, name: 'workshop 1')
    topic.products << create(:book_product, name: 'Book 1')
    topic.products << create(:video_product, name: 'Video 1')
    topic.products << create(:video_product, :inactive, name: 'Video Inactive')
    topic.articles << create(:article)

    visit topic_path(topic)

    expect_to_see_related_workshop_named 'workshop 1'
    expect_to_see_related_book_named 'Book 1'
    expect_to_see_related_video_named 'Video 1'
    expect_to_not_see_related_item_named 'Video Inactive'
  end

  scenario "view a topic's related products on the topic's articles index" do
    topic = create(:topic, name: 'Topic 1')
    topic.workshops << create(:workshop, name: 'workshop 1')
    topic.products << create(:book_product, name: 'Book 1')
    topic.products << create(:video_product, name: 'Video 1')
    topic.products << create(:video_product, :inactive, name: 'Video Inactive')
    topic.articles << create(:article)

    visit topic_path(topic)
    click_link "View related Giant Robots articles"

    expect_to_see_related_workshop_named 'workshop 1'
    expect_to_see_related_book_named 'Book 1'
    expect_to_see_related_video_named 'Video 1'
  end

  scenario "view the type for a topic's related products" do
    topic = create(:topic, name: 'Rails')
    topic.workshops << create(:in_person_workshop, name: 'In-Person Rails')
    topic.workshops << create(:online_workshop, name: 'Online Rails')

    visit topic_path(topic)

    expect_related_in_person_worshop_named('In-Person Rails')
    expect_related_online_workshop_named('Online Rails')
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
    within('aside .video') do
      expect(page).to have_content video_name
    end
  end

  def expect_to_not_see_related_item_named(name)
    within('aside') do
      expect(page).not_to have_content name
    end
  end

  def expect_related_in_person_worshop_named(workshop_name)
    expect(type_of_related_workshop_named(workshop_name)).to eq 'In Person'
  end

  def expect_related_online_workshop_named(workshop_name)
    expect(type_of_related_workshop_named(workshop_name)).to eq 'Online'
  end

  def type_of_related_workshop_named(name)
    within '.related-products' do
      find('li', text: name).find('h4').text.strip
    end
  end

  def expect_to_have_learn_resource_highlight(resource_id)
    expect(page).
      to have_css(".resource.learn-resource[data-id='#{resource_id}']")
  end

  def expect_not_to_have_learn_resource_highlight(resource_id)
    expect(page).
      not_to have_css(".resource.learn-resource[data-id='#{resource_id}']")
    expect(page).
      to have_css(".resource[data-id='#{resource_id}']")
  end
end
