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
    it "yields only beta offers not replied to by the provided user" do
      user = create(:user)
      replied_offer = create(:beta_offer, name: "replied")
      create(:beta_offer, name: "visible")
      create(:beta_reply, user: user, offer: replied_offer)
      result = []
      query = Beta::VisibleOfferQuery.new(Beta::Offer.all, user: user)

      query.each { |yielded| result << yielded }

      expect(result.map(&:name)).to eq(%w(visible))
    end
  end
end
