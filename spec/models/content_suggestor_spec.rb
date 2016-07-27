require "rails_helper"

RSpec.describe ContentSuggestor do
  describe "#next_up" do
    context "when the user has not viewed any Weekly Iterations" do
      it "returns the first Weekly Iteration in the set sequence" do
        first_video, second_video = build_stubbed_list(:video, 2)
        suggester = build_content_suggester(
          recommendables: [first_video, second_video],
        )

        result = suggester.next_up.unwrap

        expect(result).to eq(first_video)
      end
    end

    context "when the user has viewed some Weekly Iterations in the sequence" do
      it "returns the first unseen Weekly Iteration in the set sequence" do
        first_video, second_video = create_list(:video, 2)
        user = create(:user)
        create(:status, user: user, completeable: first_video)
        suggester = build_content_suggester(
          user: user,
          recommendables: [first_video, second_video, nil],
        )

        result = suggester.next_up.unwrap

        expect(result).to eq(second_video)
      end
    end

    context "when the user has viewed all Weekly Iterations in the sequence" do
      it "returns nil" do
        video = create(:video)
        user = create(:user)
        create(:status, user: user, completeable: video)
        suggester = build_content_suggester(
          user: user,
          recommendables: [video],
        )

        result = suggester.next_up

        expect(result).to be_blank
      end
    end

    context "when we've already recommended a given video" do
      it "recommends the next in the sequence" do
        first_video, second_video = create_list(:video, 2)
        user = create(:user)
        suggester = build_content_suggester(
          user: user,
          recommendables: [first_video, second_video],
          recommended: [first_video],
        )

        result = suggester.next_up.unwrap

        expect(result).to eq(second_video)
      end
    end

    def build_content_suggester(
      user: build_stubbed(:user),
      recommended: [],
      recommendables:
    )
      ContentSuggestor.new(
        user: user,
        recommendables: recommendables,
        recommended: recommended,
      )
    end
  end
end
