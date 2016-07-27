require "rails_helper"

RSpec.describe ContentSuggestor do
  describe "#next_up" do
    context "when the user has not viewed any Weekly Iterations" do
      it "returns the first Weekly Iteration in the set sequence" do
        first_video, second_video = build_stubbed_list(:video, 2)
        content_sequence = build_content_sequence(
          recommendables: [first_video, second_video],
        )

        result = content_sequence.next_up.unwrap

        expect(result).to eq(first_video)
      end
    end

    context "when the user has already viewed some Weekly Iterations in the sequence" do
      it "returns the first unseen Weekly Iteration in the set sequence" do
        first_video, second_video = create_list(:video, 2)
        user = create(:user)
        create(:status, user: user, completeable: first_video)
        content_sequence = build_content_sequence(
          user: user,
          recommendables: [first_video, second_video, nil],
        )

        result = content_sequence.next_up.unwrap

        expect(result).to eq(second_video)
      end
    end

    context "when the user has already viewed every Weekly Iterations in the sequence" do
      it "returns nil" do
        video = create(:video)
        user = create(:user)
        create(:status, user: user, completeable: video)
        content_sequence = build_content_sequence(
          user: user,
          recommendables: [video],
        )

        result = content_sequence.next_up

        expect(result).to be_blank
      end
    end

    context "when we've already recommended a given video" do
      it "recommends the next in the sequence" do
        first_video, second_video = create_list(:video, 2)
        user = create(:user)
        create(:content_recommendation, user: user, recommendable: first_video)
        content_sequence = build_content_sequence(
          user: user,
          recommendables: [first_video, second_video],
          recommendations: ContentRecommendation.all,
        )

        result = content_sequence.next_up.unwrap

        expect(result).to eq(second_video)
      end
    end

    def build_content_sequence(
      user: build_stubbed(:user),
      recommendations: ContentRecommendation.none,
      recommendables:
    )
      ContentSuggestor.new(
        user: user,
        recommendables: recommendables,
        recommendations: recommendations
      )
    end
  end
end
