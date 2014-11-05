class StripeCustomerCollection
  REMAINING = 200

  include Enumerable

  def initialize(per_page:)
    @per_page = per_page
  end

  def each(&block)
    fetch({ limit: per_page }, remaining: REMAINING, block: block)
  end

  private

  def fetch(options, remaining:, block:)
    customers = Stripe::Customer.all(options).to_a

    if customers.any? && remaining > 0
      customers.each(&block)
      fetch(
        options.merge(starting_after: customers.last["id"]),
        block: block,
        remaining: remaining - 1,
      )
    end
  end

  attr_reader :per_page
end
