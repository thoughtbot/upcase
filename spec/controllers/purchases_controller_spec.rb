require 'spec_helper'

include StubCurrentUserHelper

describe PurchasesController, '#new when purchasing a product as a user with an active subscription' do
  it 'renders a subscriber-specific layout' do
    user = create(:user, :with_subscription)
    stub_current_user_with(user)

    get :new, product_id: create(:video_product)
    expect(response).to render_template('purchases/for_subscribers')
  end
end

describe PurchasesController, "processing on stripe" do
  it "creates and saves a stripe customer and charges it for the product" do
    stub_current_user_with(create(:user))
    product = create(:product)
    stripe_token = 'token'
    post :create, purchase: customer_params(stripe_token), product_id: product.to_param

    FakeStripe.should have_charged(1500).to('test@example.com').with_token(stripe_token)
  end
end

describe PurchasesController, 'creating a subscription' do
  it 'notifies KissMetrics of signup' do
    stub_current_user_with(create(:user))
    product = create(:subscribeable_product)
    stripe_token = 'token'
    post :create, purchase: customer_params(stripe_token), product_id: product
    purchase = assigns(:purchase)
    FakeKissmetrics.events_for(purchase.email).should == ['Billed']
    FakeKissmetrics.properties_for(purchase.email, 'Billed').should == [{ 'Product Name' => product.name, 'Billed Amount' => purchase.price }]
  end

end

describe PurchasesController, "processing on paypal" do
  it "starts a paypal transaction and saves a purchase for the product" do
    stub_current_user_with(create(:user))
    product = create(:product)
    post :create, purchase: { variant: "individual", name: "User", email: "test@example.com", payment_method: "paypal" }, product_id: product.to_param

    response.status.should == 302
    response.location.should == FakePaypal.outgoing_uri
    assigns(:purchase).should_not be_paid
  end
end

describe PurchasesController, "product is not paid" do
  let(:product) { create(:product, individual_price: 15) }
  let(:purchase) { create(:purchase, purchaseable: product) }

  it "redirects from show to the product page" do
    purchase.paid = false
    purchase.save
    stub_current_user_with(create(:user))
    get :show, id: purchase.to_param
    response.should redirect_to(product_path(product))
  end

  it "redirects from watch to the product page" do
    purchase.paid = false
    purchase.save
    stub_current_user_with(create(:user))
    get :watch, id: purchase.to_param
    response.should redirect_to(root_path)
  end
end

def customer_params(token)
  {
    name: 'User',
    email: 'test@example.com',
    variant: "individual",
    stripe_token: token,
    payment_method: "stripe"
  }
end
