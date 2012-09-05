require 'spec_helper'

describe PurchasesController, "processing on stripe" do
  let(:stripe_token) { "stripetoken" }
  let(:product) { create(:product, individual_price: 15) }
  let(:user) { create(:user) }

  it "creates and saves a stripe customer and charges it for the product" do
    controller.stubs(:current_user).returns(user)
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
  let(:user) { create(:user) }

  it "starts a paypal transaction and saves a purchase for the product" do
    controller.stubs(:current_user).returns(user)
    product = create(:product)
    post :create, purchase: { variant: "individual", name: "User", email: "test@example.com", payment_method: "paypal" }, product_id: product.to_param

    response.status.should == 302
    response.location.should == FakePaypal.outgoing_uri
    assigns(:purchase).should_not be_paid
  end
end

describe PurchasesController, "product is not paid" do
  let(:product) { create(:product, individual_price: 15) }
  let(:user) { create(:user) }
  let(:purchase) { create(:purchase, product: product) }

  it "redirects from show to the product page" do
    purchase.paid = false
    purchase.save
    controller.stubs(:current_user).returns(user)
    get :show, product_id: product.to_param, id: purchase.to_param
    response.should redirect_to(product_path(product))
  end

  it "redirects from watch to the product page" do
    purchase.paid = false
    purchase.save
    controller.stubs(:current_user).returns(user)
    get :watch, product_id: product.to_param, id: purchase.to_param
    response.should redirect_to(product_path(product))
  end
end
