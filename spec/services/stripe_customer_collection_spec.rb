require "rails_helper"

describe StripeCustomerCollection do
  describe "#each" do
    it "yields each customer from API" do
      customer_ids = 25.times.map { generate(:uuid) }
      FakeStripe.customer_ids = customer_ids
      collection = StripeCustomerCollection.new(per_page: 2)
      result = []

      collection.each { |yielded| result << yielded }

      expect(result.map { |customer| customer["id"] }).to eq(customer_ids)
    end

    it "doesn't call recursively more than `remaining` times" do
      customers_count = StripeCustomerCollection::REMAINING + 1
      customer_ids = customers_count.times.map { generate(:uuid) }
      FakeStripe.customer_ids = customer_ids
      collection = StripeCustomerCollection.new(per_page: 1)
      result = []

      collection.each { |yielded| result << yielded }

      expect(result.count).to eq(customers_count - 1)
    end
  end
end
