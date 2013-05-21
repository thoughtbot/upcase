require 'spec_helper'

describe SubscriptionInvoice do
  it 'retrieves all invoices for a customer' do
    invoices = SubscriptionInvoice.
      find_all_by_stripe_customer_id('cus_1KjDojUy0RiwFH')

    invoices.length.should eq 1
    invoices.first.stripe_invoice_id.should eq 'in_1s4JSgbcUaElzU'
  end

  it 'does not find invoices with a blank customer' do
    SubscriptionInvoice.find_all_by_stripe_customer_id(' ').length.should eq 0
    SubscriptionInvoice.find_all_by_stripe_customer_id('').length.should eq 0
    SubscriptionInvoice.find_all_by_stripe_customer_id(nil).length.should eq 0
  end

  describe 'invoice fields' do
    let(:invoice) { SubscriptionInvoice.new('in_1s4JSgbcUaElzU') }

    it 'has a number equal to its subscription id and date' do
      date = Time.at(1369159688)
      invoice.number.should == date.to_s(:invoice)
    end

    it 'returns the invoice total from stripe' do
      invoice.total.should == 79
    end

    it 'returns the invoice subtotal from stripe' do
      invoice.subtotal.should == 99
    end

    it 'returns the amount_due from stripe' do
      invoice.amount_due.should == 79
    end

    it 'returns the invoice paid status from stripe' do
      invoice.should be_paid
    end

    it 'returns the invoice date from stripe' do
      invoice.date.should eq Time.at(1369159688)
    end

    it 'returns the subscription name from stripe' do
      invoice.subscription_item_name.should eq "Subscription to Prime"
    end

    it 'returns the subscription billed amount from stripe' do
      invoice.subscription_item_amount.should eq 99
    end

    it 'returns true if there is a discount on the invoice' do
      invoice.should be_discounted
    end

    it 'returns the name of the discount from stripe' do
      invoice.discount_name.should eq 'railsconf'
    end

    it 'returns the amount of the discount from stripe' do
      invoice.discount_amount.should eq 20
    end

    it 'returns the user who matches the stripe customer' do
      user = create(:user, stripe_customer_id: "cus_1KjDojUy0RiwFH")

      invoice.user.should eq user
    end

    it 'returns a zero balance when paid' do
      invoice.balance.should eq 0.00
    end

    it 'returns a balance equal to the amount_due when not paid' do
      stripe_invoice = SubscriptionInvoice.new('in_1s4JSgbcUaElzU')
      stub_invoice = stub(paid: false, amount_due: 500)
      Stripe::Invoice.stubs(:retrieve).returns(stub_invoice)

      invoice.balance.should eq 5.00
    end

    describe 'amount_paid' do
      it 'returns zero when not paid' do
        stripe_invoice = SubscriptionInvoice.new('in_1s4JSgbcUaElzU')
        stub_invoice = stub(paid: false)
        Stripe::Invoice.stubs(:retrieve).returns(stub_invoice)

        invoice.amount_paid.should eq 0.00
      end

      it 'returns the amount_due when paid' do
        stripe_invoice = SubscriptionInvoice.new('in_1s4JSgbcUaElzU')
        stub_invoice = stub(paid: true, amount_due: 500)
        Stripe::Invoice.stubs(:retrieve).returns(stub_invoice)

        invoice.amount_paid.should eq 5.00
      end
    end

    it 'returns the user info for the user' do
      user = create(
        :user,
        stripe_customer_id: "cus_1KjDojUy0RiwFH",
        organization: 'thoughtbot',
        address1: '41 Winter St.',
        address2: 'Floor 7',
        city: 'Boston',
        state: 'MA',
        zip_code: '02108',
        country: 'USA'
      )

      invoice.user_name.should == user.name
      invoice.user_organization.should eq user.organization
      invoice.user_address1.should eq user.address1
      invoice.user_address2.should eq user.address2
      invoice.user_city.should eq user.city
      invoice.user_state.should eq user.state
      invoice.user_zip_code.should eq user.zip_code
      invoice.user_country.should eq user.country
    end

    it 'returns the proper partial path' do
      invoice.to_partial_path.should eq 'subscriber/invoices/subscription_invoice'
    end
  end
end
