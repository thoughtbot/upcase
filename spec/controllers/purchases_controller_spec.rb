require 'spec_helper'

describe PurchasesController, "processing on stripe" do
  let(:stripe_token) { "stripetoken" }
  let(:customer) { stub(:id => "stripeid") }
  let(:product) { Factory(:product, :individual_price => 15) }

  before do
    Stripe::Customer.stubs(:create).returns(customer)
    Stripe::Charge.stubs(:create).returns(stub(:id => "TRANSACTION-ID"))
    FetchAPI::Order.stubs(:create)
    FetchAPI::Order.stubs(:find).returns(stub(:link_full => "http://fetchurl"))
  end

  it "creates and saves a stripe customer and charges it for the product" do
    product = Factory(:product)
    post :create, :purchase => { :variant => "individual", :name => "User", :email => "test@example.com", :stripe_token => stripe_token, :payment_method => "stripe" }, :product_id => product.to_param

    Stripe::Customer.should have_received(:create).with(:card => stripe_token, :description => "test@example.com", :email => "test@example.com")
    Stripe::Charge.should have_received(:create).with(:amount => 1500, :currency => "usd", :customer => customer.id, :description => product.name)

    Purchase.first.stripe_customer.should == customer.id
  end
end

describe PurchasesController, "processing on paypal" do
  let(:product) { Factory(:product, :individual_price => 15) }

  before do
    FetchAPI::Order.stubs(:create)
    FetchAPI::Order.stubs(:find).returns(stub(:link_full => "http://fetchurl"))
  end

  it "starts a paypal transaction and saves a purchase for the product" do
    product = Factory(:product)
    post :create, :purchase => { :variant => "individual", :name => "User", :email => "test@example.com", :payment_method => "paypal" }, :product_id => product.to_param

    response.status.should == 302
    response.location.should == FakePaypal.outgoing_uri
    assigns(:purchase).should_not be_paid
  end
end
