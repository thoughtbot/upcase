class StripeCustomerCollection
  include Enumerable

  def initialize(per_page:)
    @per_page = per_page
  end

  def each(&block)
    fetch({ limit: per_page }, block: block)
  end

  private

  def fetch(options, block:)
    customers = Stripe::Customer.all(options).to_a

    if customers.any?
      customers.each(&block)
      fetch(
        options.merge(starting_after: customers.last["id"]),
        block: block,
      )
    end
  end

  attr_reader :per_page
end
