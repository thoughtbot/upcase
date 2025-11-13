require "rails_helper"

RSpec.describe VideoDurationUpdater do
  include WistiaApiClientStubs

  describe ".update_all_durations" do
    context "when videos exist in Wistia and locally" do
      it "updates the length_in_minutes attributes for all videos in wistia" do
        video1 = create(
          :video,
          name: "Vim for Rails Developers",
          length_in_minutes: nil
        )
        video2 = create(
          :video,
          name: "humans present tmux",
          length_in_minutes: 17
        )
        wistia_response = [
          {
            "name" => video1.name,
            "duration" => 3600,
            "hashed_id" => video1.wistia_id
          },
          {
            "name" => video2.name,
            "duration" => 578,
            "hashed_id" => video2.wistia_id
          }
        ]
        stub_wistia_api_client(response: wistia_response)

        described_class.update_all_durations
        video1.reload
        video2.reload

        expect(video1.length_in_minutes).to eq 60
        expect(video2.length_in_minutes).to eq 10
      end
    end

    context "when Wistia returns videos that don't exist locally" do
      it "skips them" do
        local_video = create(:video, length_in_minutes: nil)
        wistia_response = [
          {
            "name" => "Vim for Rails Developers",
            "duration" => 3600.05,
            "hashed_id" => "947f4c35d9"
          },
          {
            "name" => "chrome-dev-tools.mov",
            "duration" => 630,
            "hashed_id" => "04ccec11ed"
          },
          {
            "name" => local_video.name,
            "duration" => 1500,
            "hashed_id" => "m4keb3li3v3"
          }
        ]
        stub_wistia_api_client(response: wistia_response)

        described_class.update_all_durations
        local_video.reload

        expect(local_video.length_in_minutes).to eq 25
      end
    end
  end

  describe "#update_duration" do
    context "when duration is only 10 seconds above the nearest minute" do
      it "rounds down when updating the video's length in minutes" do
        video = create(:video, length_in_minutes: nil)
        show_response = {
          "name" => video.name,
          "duration" => 68,
          "hashed_id" => "m4keb3li3v3"
        }
        stub_wistia_api_client(response: show_response)

        described_class.update_duration(video)
        video.reload

        expect(video.length_in_minutes).to eq 1
      end
    end

    context "when duration more than 10 seconds above the nearest minute" do
      it "rounds up when updating the video's length in minutes" do
        video = create(:video, length_in_minutes: nil)
        show_response = {
          "name" => video.name,
          "duration" => 71,
          "hashed_id" => "m4keb3li3v3"
        }
        stub_wistia_api_client(response: show_response)

        described_class.update_duration(video)
        video.reload

        expect(video.length_in_minutes).to eq 2
      end
    end

    it "updates the passed in video's duration with the retrieved value" do
      video = create(
        :video,
        wistia_id: "foo",
        name: "humans present refactoring",
        length_in_minutes: nil
      )

      show_response = {
          "name" => video.name,
          "duration" => 4_265 # seconds
      }

      stub_wistia_api_client(response: show_response)

      described_class.update_duration(video)
      video.reload

      expect(video.length_in_minutes).to eq 71
    end
  end
end
