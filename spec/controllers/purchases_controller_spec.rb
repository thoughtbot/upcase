require 'spec_helper'

include StubCurrentUserHelper

describe PurchasesController do
  describe '#new when purchasing a screencast as a user with an active subscription' do
    it 'renders a subscriber-specific layout' do
      user = create(:subscriber)
      product = create(:screencast)
      stub_current_user_with(user)

      get :new, product_id: product

      expect(response).to(
        redirect_to(new_subscriber_screencast_purchase_path(product))
      )
    end
  end

  describe '#new when purchasing a plan as a user with an active subscription' do
    context 'when purchasing an individual plan' do
      it 'renders a subscriber-specific layout' do
        user = create(:subscriber)
        stub_current_user_with(user)

        get :new, individual_plan_id: user.subscription.plan

        expect(response).to redirect_to dashboard_path
      end
    end

    context 'when purchasing a team plan' do
      it 'renders a subscriber-specific layout' do
        user = create(:subscriber)
        stub_current_user_with(user)

        get :new, teams_team_plan_id: user.subscription.plan

        expect(response).to redirect_to dashboard_path
      end
    end
  end

  describe '#new with no variant specified' do
    it 'defaults purchase to individual' do
      user = create(:user)
      product = create(:screencast)
      stub_current_user_with(user)

      get :new, product_id: product

      expect(assigns(:purchase).variant).to eq 'individual'
    end
  end

  describe '#new with company variant specified' do
    it 'defaults purchase to company' do
      user = create(:user)
      product = create(:screencast)
      stub_current_user_with(user)

      get :new, product_id: product, variant: 'company'

      expect(assigns(:purchase).variant).to eq 'company'
    end
  end

  describe '#new when attempting to purchase a workshop' do
    it 'redirects to the subscription page' do
      user = create(:user)
      workshop = create(:workshop)
      stub_current_user_with(user)

      get :new, workshop_id: workshop.id

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

  it 'sets flash[:purchase_paid_price]' do
    stub_current_user_with(create(:user))
    product = create(:product)

    post :create, purchase: customer_params, product_id: product

    flash[:purchase_amount].should eq product.individual_price
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
    let(:product) { create(:book, individual_price: 15) }
    let(:purchase) { create(:purchase, purchaseable: product) }

    it "redirects from show to the product page" do
      purchase.paid = false
      purchase.save
      stub_current_user_with(create(:user))

      get :show, id: purchase.to_param

      response.should redirect_to(book_path(product))
    end
  end

  describe 'purchasing a team plan when there is more than one' do
    it 'uses the requested plan' do
      user = create(:user)
      stub_current_user_with(user)

      create(:team_plan, sku: 'sku1')
      desired_plan = create(:team_plan, sku: 'sku2')

      get :new, teams_team_plan_id: desired_plan.sku

      expect(assigns(:purchase).purchaseable).to eq desired_plan
    end
  end

  describe '#show' do
    it 'should response with 404 if no purchase found' do
      expect{
        get :show, id: 'robots.txt'
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#index' do
    it 'assigns paid purchases belonging to the current user' do
      user = create(:user, :with_github)
      purchase_two = create(
        :paid_purchase,
        user: user,
        created_at: 5.minute.ago
      )
      purchase_one = create(
        :paid_purchase,
        user: user,
        created_at: 1.minute.ago
      )
      create(:unpaid_purchase, user: user)
      create(:plan_purchase, user: user)
      create(:paid_purchase, user: create(:user))
      stub_current_user_with(user)

      get :index

      expect(assigns(:purchases)).to eq([purchase_one, purchase_two])
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
