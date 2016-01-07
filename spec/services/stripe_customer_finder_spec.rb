require "rails_helper"

describe StripeCustomerFinder do
  it "gets the Customer as per normal if everything is ok" do
    stripe_succeeds(id: "cus_123")

    customer = StripeCustomerFinder.retrieve("cus_123")

    expect(customer).to eq :customer
  end

  it "raises if the customer isn't there" do
    stripe_fails_normally

    expect do
      StripeCustomerFinder.retrieve(1)
    end.to raise_error(Stripe::InvalidRequestError)
  end

  it "raises if we are in test but Stripe knows what you meant" do
    in_environment("test")
    stripe_fails_but_knows_what_you_meant

    expect do
      StripeCustomerFinder.retrieve("cus_123")
    end.to raise_error(Stripe::InvalidRequestError)
  end

  it "returns a fake customer if the error is right and we're on development" do
    in_environment("development")
    stripe_fails_but_knows_what_you_meant

    customer = StripeCustomerFinder.retrieve("cus_123")

    expect(customer).to be_a Stripe::Customer
    expect(customer.id).to eq "cus_123"
  end

  def stripe_succeeds(id:)
    allow(Stripe::Customer).to receive(:retrieve).with(id).and_return(:customer)
  end

  def stripe_fails_normally
    allow(Stripe::Customer).
      to receive(:retrieve).
      and_raise(Stripe::InvalidRequestError.new("", {}))
  end

  def stripe_fails_but_knows_what_you_meant
    allow(Stripe::Customer).
      to receive(:retrieve).
      and_raise(Stripe::InvalidRequestError.new(stripe_error_message, {}))
  end

  def stripe_error_message
    "Hark! An error! #{StripeCustomerFinder::ERROR_MESSAGE}"
  end

  def in_environment(env)
    allow(Rails).
      to receive(:env).
      and_return(ActiveSupport::StringInquirer.new(env))
  end
end
