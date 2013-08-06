require 'spec_helper'

feature 'Viewing a podcast' do
  scenario 'Visitor views the list of published podcast episodes for a show' do
    episode1 = create(
      :episode,
      title: 'Good episode',
      description: 'this was good', 
      duration: 1210
    )
    create(
      :episode,
      title: 'Not so good',
      description: 'this was bad',
      duration: 0,
      show: episode1.show
    )
    create(:future_episode, title: 'Future episode', show: episode1.show)
    create(:future_episode, title: 'Another show')

    visit show_episodes_path(episode1.show)

    expect(page).to have_content 'Good episode'
    expect(page).to have_content 'this was good'
    expect(page).to have_content '20 minutes'
    expect(page).to have_content 'Not so good'
    expect(page).to have_content 'this was bad'
    expect(page).not_to have_content 'Future episode'
    expect(page).not_to have_content 'Another show'
  end

  scenario 'Visitor views an individual podcast episode' do
    episode = create(
      :episode,
      title: 'Good episode',
      description: 'this was good', 
      file_size: 13540249,
      duration: 1210
    )

    visit show_episodes_path(episode.show)
    click_link 'Good episode'

    expect_to_see_episode_information(episode)
    expect_to_see_audio_player(episode)
  end

  scenario 'Visitor views a podcast episode with related content' do
    ruby = create(:topic, name: 'Ruby')
    asp = create(:topic, name: 'ASP.net')
    episode = create(:episode, title: 'Good episode')
    book = create(:book_product, name: 'Awesome product')
    video = create(:video_product, name: 'Awesome video')
    inactive_video = create(:video_product, name: 'Bad product', active: false)
    workshop = create(:workshop, name: 'Awesome workshop')
    inactive_workshop = create(:workshop, name: 'Bad workshop', active: false)
    ruby.episodes << episode
    ruby.products << book
    asp.products << video
    ruby.products << inactive_video
    ruby.workshops << workshop
    ruby.workshops << inactive_workshop

    visit show_episodes_path(episode.show)
    click_link 'Good episode'

    expect(page).to have_content('Awesome product')
    within('aside') do
      expect(page).to have_content('Ruby')
      expect(page).to have_content('Awesome product')
      expect(page).to have_content('Awesome workshop')
      expect(page).not_to have_content('ASP.net')
      expect(page).not_to have_content('Bad product')
      expect(page).not_to have_content('Bad workshop')
    end
  end

  def expect_to_see_episode_information(episode)
    expect(page).to have_css('h2', text: episode.title)
    expect(page).to have_css('h3', text: "Episode ##{episode.number}")
    expect(page).to have_css('.listen', text: /13 MB,/)
    expect(page).to have_css('.listen', text: /20 minutes/)
  end

  def expect_to_see_audio_player(episode)
    expect(page).
      to have_css("audio source[src='#{show_episode_path(episode.show, episode, format: :mp3)}']")
  end
end

