require 'spec_helper'

include StubCurrentUserHelper

describe PurchasesController do
  describe '#new when purchasing a product as a user with an active subscription' do
    it 'renders a subscriber-specific layout' do
      user = create(:user, :with_subscription)
      stub_current_user_with(user)

      get :new, product_id: create(:video_product)

      expect(response).to render_template('purchases/for_subscribers')
    end
  end

  describe 'processing on stripe' do
    it 'creates and saves a stripe customer and charges it for the product' do
      stub_current_user_with(create(:user))
      product = create(:product)
      stripe_token = 'token'

      post :create, purchase: customer_params(stripe_token), product_id: product.to_param

      FakeStripe.should have_charged(1500).to('test@example.com').with_token(stripe_token)
    end
  end

  describe 'creating a subscription' do
    it 'sends a message to the notifier' do
      stub_current_user_with(create(:user))
      product = create(:subscribeable_product)
      notifier = stub('notifier', :notify_of)
      KissmetricsEventNotifier.stubs(:new).returns(notifier)

      post :create, purchase: customer_params, product_id: product

      notifier.should have_received(:notify_of).with(assigns(:purchase))
    end
  end

  describe "processing on paypal" do
    it "starts a paypal transaction and saves a purchase for the product" do
      stub_current_user_with(create(:user))
      product = create(:product)

      post :create, purchase: { variant: "individual", name: "User", email: "test@example.com", payment_method: "paypal" }, product_id: product.to_param

      response.status.should == 302
      response.location.should == FakePaypal.outgoing_uri
      assigns(:purchase).should_not be_paid
    end
  end

  describe "product is not paid" do
    let(:product) { create(:product, individual_price: 15) }
    let(:purchase) { create(:purchase, purchaseable: product) }

    it "redirects from show to the product page" do
      purchase.paid = false
      purchase.save
      stub_current_user_with(create(:user))

      get :show, id: purchase.to_param

      response.should redirect_to(product_path(product))
    end
  end

  def customer_params(token='stripe token')
    {
      name: 'User',
      email: 'test@example.com',
      variant: "individual",
      stripe_token: token,
      payment_method: "stripe"
    }
  end
end
