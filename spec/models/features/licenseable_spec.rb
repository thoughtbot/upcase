require "rails_helper"

describe Features::Licenseable do
  describe "#unfulfill" do
    it "deletes licenses of the correct type" do
      user = create(:user)
      video_license = create(
        :license,
        user: user,
        licenseable: create(:video_tutorial)
      )
      repo_license = create(
        :license,
        user: user,
        licenseable: create(:repository)
      )
      video_tutorial_feature = Features::Licenseable.new(
        licenseable_type: "Repository",
        user: user
      )

      video_tutorial_feature.unfulfill

      expect(user.reload.licenses).to eq [video_license]
    end
  end
end
