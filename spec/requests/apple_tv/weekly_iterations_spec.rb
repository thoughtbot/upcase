require "rails_helper"

describe "Weekly Iteration" do
  describe "#index" do
    it "displays links to all the videos" do
      show = create(:the_weekly_iteration)
      episodes = create_list(:video, 10, :published, watchable: show)

      get "/apple_tv/weekly_iterations.xml"

      episodes.each do |episode|
        expect(all_episode_titles).to include(episode.name)
      end
    end

    it "includes data-video attribute for each video" do
      show = create(:the_weekly_iteration)
      episode = create(:video, :published, wistia_id: 12, watchable: show)

      get "/apple_tv/weekly_iterations.xml"

      first_episode = all_videos.first
      expected_url = episode.download_url("original")
      expect(first_episode["data-video"]).to eq(expected_url)
    end

    it "includes the video attributes for related content" do
      show = create(:the_weekly_iteration)
      episode = create(
        :video,
        :published,
        summary: "Our best show yet!",
        watchable: show,
      )

      get "/apple_tv/weekly_iterations.xml"

      first_episode = all_videos.first
      subtitle = first_episode.find("[data-role=subtitle]").text
      summary = first_episode.find("[data-role=description]").text
      expect(subtitle).to eq(episode.published_on.to_formatted_s(:simple))
      expect(summary).to eq(episode.summary)
    end
  end

  def all_videos
    @all_videos ||= page.all("[data-role=video]")
  end

  def all_episode_titles
    @all_episode_title ||= page.all("[data-role=primary-title]").map(&:text)
  end

  def page
    Capybara::Node::Simple.new(response.body)
  end
end
