Then /^I should see information about the episode "([^"]*)"$/ do |episode_title|
  episode = Episode.find_by_title!(episode_title)
  page.should have_css('h2', text: "Episode ##{episode.id}")
  page.should have_css('h3', text: episode.title)
  page.should have_css('.listen', text: "13 MB, 20 minutes")
end

Then /^I should see an audio player for the episode "([^"]*)"$/ do |episode_title|
  episode = Episode.find_by_title!(episode_title)
  page.should have_css("audio source[src='#{episode_path(episode, format: :mp3)}']")
end
