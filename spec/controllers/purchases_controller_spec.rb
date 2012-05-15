require 'spec_helper'

describe PurchasesController, "processing on stripe" do
  let(:stripe_token) { "stripetoken" }
  let(:product) { create(:product, individual_price: 15) }

  before do
    FetchAPI::Order.stubs(:create)
    FetchAPI::Order.stubs(:find).returns(stub(link_full: "http://fetchurl"))
  end

  it "creates and saves a stripe customer and charges it for the product" do
    product = create(:product)
    customer_params = {
      name: 'User',
      email: 'test@example.com',
      variant: "individual",
      stripe_token: stripe_token,
      payment_method: "stripe"
    }

    post :create, purchase: customer_params, product_id: product.to_param

    FakeStripe.should have_charged(1500).to('test@example.com').with_token(stripe_token)
  end
end

describe PurchasesController, "processing on paypal" do
  let(:product) { create(:product, individual_price: 15) }

  before do
    FetchAPI::Order.stubs(:create)
    FetchAPI::Order.stubs(:find).returns(stub(link_full: "http://fetchurl"))
  end

  it "starts a paypal transaction and saves a purchase for the product" do
    product = create(:product)
    post :create, purchase: { variant: "individual", name: "User", email: "test@example.com", payment_method: "paypal" }, product_id: product.to_param

    response.status.should == 302
    response.location.should == FakePaypal.outgoing_uri
    assigns(:purchase).should_not be_paid
  end
end
