require 'spec_helper'

include StubCurrentUserHelper

describe PurchasesController do
  describe '#new when purchasing a product as a user with an active subscription' do
    it 'renders a subscriber-specific layout' do
      user = create(:user, :with_subscription)
      product = create(:video_product)
      stub_current_user_with(user)

      get :new, product_id: product

      expect(response).to(
        redirect_to(new_subscriber_product_purchase_path(product))
      )
    end
  end

  describe '#new when purchasing a plan as a user with an active subscription' do
    context 'when purchasing an individual plan' do
      it 'renders a subscriber-specific layout' do
        user = create(:user, :with_subscription)
        stub_current_user_with(user)

        get :new, individual_plan_id: user.subscription.plan

        expect(response).to redirect_to dashboard_path
      end
    end

    context 'when purchase a team plan' do
      it 'renders a subscriber-specific layout' do
        user = create(:user, :with_subscription)
        stub_current_user_with(user)

        get :new, team_plan_id: user.subscription.plan

        expect(response).to redirect_to dashboard_path
      end
    end
  end

  describe '#new with no variant specified' do
    it 'defaults purchase to individual' do
      user = create(:user)
      product = create(:video_product)
      stub_current_user_with(user)

      get :new, product_id: product

      expect(assigns(:purchase).variant).to eq 'individual'
    end
  end

  describe '#new with company variant specified' do
    it 'defaults purchase to company' do
      user = create(:user)
      product = create(:video_product)
      stub_current_user_with(user)

      get :new, product_id: product, variant: 'company'

      expect(assigns(:purchase).variant).to eq 'company'
    end
  end

  describe '#new when attempting to purchase a workshop' do
    it 'redirects to the subscription page' do
      user = create(:user)
      section = create(:section)
      stub_current_user_with(user)

      get :new, section_id: section.id

      expect(response).to redirect_to new_subscription_path
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
      create_mentors
      stub_current_user_with(create(:user, :with_github))
      plan = create(:plan)
      notifier = stub('notifier', :notify_of_purchase)
      KissmetricsEventNotifier.stubs(:new).returns(notifier)

      post :create, purchase: customer_params, individual_plan_id: plan

      notifier.should have_received(:notify_of_purchase).with(assigns(:purchase))
    end
  end

  it 'saves a comment for section purchase' do
    stub_current_user_with(create(:user))
    product = create(:product)

    post :create, purchase: customer_params.merge(comments: 'test-comment'), product_id: product

    assigns(:purchase).comments.should == 'test-comment'
  end

  it 'sets flash[:purchase_paid_price]' do
    stub_current_user_with(create(:user))
    product = create(:product)

    post :create, purchase: customer_params, product_id: product

    flash[:purchase_paid_price].should eq product.individual_price
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
