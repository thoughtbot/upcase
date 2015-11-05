require "rails_helper"

describe Beta::VisibleOfferQuery do
  it "is enumerable" do
    query = Beta::VisibleOfferQuery.new(
      Beta::Offer.all,
      user: build_stubbed(:user),
    )

    expect(query).to be_a(Enumerable)
  end

  describe "#each" do
    context "for a user who has completed at least one trail" do
      it "yields only beta offers not replied to by the provided user" do
        user = create_user_with_trail_status(Status::COMPLETE)
        replied_offer = create(:beta_offer, name: "replied")
        create(:beta_offer, name: "visible")
        create(:beta_reply, user: user, offer: replied_offer)

        result = visible_offers_for(user: user)

        expect(result.map(&:name)).to eq(%w(visible))
      end
    end

    context "for a user who hasn't completed any trails yet" do
      it "hides beta offers" do
        user = create_user_with_trail_status(Status::IN_PROGRESS)
        create(:beta_offer)

        result = visible_offers_for(user: user)

        expect(result).to be_empty
      end
    end
  end

  def visible_offers_for(user:)
    result = []
    query = Beta::VisibleOfferQuery.new(Beta::Offer.all, user: user)
    query.each { |yielded| result << yielded }
    result
  end

  def create_user_with_trail_status(state)
    create(:user).tap do |user|
      trail = create(:trail)
      create(:status, user: user, completeable: trail, state: state)
    end
  end
end
