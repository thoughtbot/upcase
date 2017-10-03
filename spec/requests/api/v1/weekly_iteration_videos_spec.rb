require "rails_helper"

describe "weekly iteration videos" do
  context "when unauthenticated" do
    it "returns a list of weekly iteration videos" do
      show = create(:the_weekly_iteration)
      video = create(:video, watchable: show)

      get "/upcase/api/v1/shows/the-weekly-iteration/videos"

      expect(response).to be_success
      expect(response_json).to match({
        "videos" => [
          a_hash_including("id" => video.id),
        ]
      })
    end
  end

  def response_json
    JSON.parse(response.body)
  end
end
