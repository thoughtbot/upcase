require "rails_helper"

describe Invoice do
  it 'retrieves all invoices for a customer' do
    invoices = Invoice.
      find_all_by_stripe_customer_id(FakeStripe::CUSTOMER_ID)

    expect(invoices.length).to eq 1
    expect(invoices.first.stripe_invoice_id).to eq FakeStripe::INVOICE_ID
  end

  it 'does not find invoices with a blank customer' do
    expect(Invoice.find_all_by_stripe_customer_id(" ").length).to eq 0
    expect(Invoice.find_all_by_stripe_customer_id("").length).to eq 0
    expect(Invoice.find_all_by_stripe_customer_id(nil).length).to eq 0
  end

  describe 'invoice fields' do
    let(:invoice) { Invoice.new(FakeStripe::INVOICE_ID) }

    it 'has a number equal to its subscription id and date' do
      date = Time.zone.at(1369159688)
      expect(invoice.number).to eq date.to_s(:invoice)
    end

    it 'returns the invoice total from stripe' do
      expect(invoice.total).to eq 79
    end

    it 'returns the invoice subtotal from stripe' do
      expect(invoice.subtotal).to eq 99
    end

    it 'returns the amount_due from stripe' do
      expect(invoice.amount_due).to eq 79
    end

    it 'returns the invoice paid status from stripe' do
      expect(invoice).to be_paid
    end

    it 'returns the invoice date from stripe' do
      expect(invoice.date).to eq Time.zone.at(1369159688)
    end

    it 'returns true if there is a discount on the invoice' do
      expect(invoice).to be_discounted
    end

    it 'returns the name of the discount from stripe' do
      expect(invoice.discount_name).to eq "railsconf"
    end

    it 'returns the amount of the discount from stripe' do
      expect(invoice.discount_amount).to eq 20
    end

    it 'returns the user who matches the stripe customer' do
      user = create(:user, stripe_customer_id: FakeStripe::CUSTOMER_ID)

      expect(invoice.user).to eq user
    end

    it 'returns a zero balance when paid' do
      expect(invoice.balance).to eq 0.00
    end

    it 'returns a balance equal to the amount_due when not paid' do
      Invoice.new(FakeStripe::INVOICE_ID)
      stub_invoice = stub(paid: false, amount_due: 500)
      Stripe::Invoice.stubs(:retrieve).returns(stub_invoice)

      expect(invoice.balance).to eq 5.00
    end

    describe '#amount_paid' do
      it 'returns zero when not paid' do
        Invoice.new(FakeStripe::INVOICE_ID)
        stub_invoice = stub(paid: false)
        Stripe::Invoice.stubs(:retrieve).returns(stub_invoice)

        expect(invoice.amount_paid).to eq 0.00
      end

      it 'returns the amount_due when paid' do
        Invoice.new(FakeStripe::INVOICE_ID)
        stub_invoice = stub(paid: true, amount_due: 500)
        Stripe::Invoice.stubs(:retrieve).returns(stub_invoice)

        expect(invoice.amount_paid).to eq 5.00
      end
    end

    it 'returns the user info for the user' do
      user = create(
        :user,
        stripe_customer_id: FakeStripe::CUSTOMER_ID,
        organization: 'thoughtbot',
        address1: '41 Winter St.',
        address2: 'Floor 7',
        city: 'Boston',
        state: 'MA',
        zip_code: '02108',
        country: 'USA'
      )

      expect(invoice.user_name).to eq user.name
      expect(invoice.user_organization).to eq user.organization
      expect(invoice.user_address1).to eq user.address1
      expect(invoice.user_address2).to eq user.address2
      expect(invoice.user_city).to eq user.city
      expect(invoice.user_state).to eq user.state
      expect(invoice.user_zip_code).to eq user.zip_code
      expect(invoice.user_country).to eq user.country
      expect(invoice.user_email).to eq user.email
    end

    it 'returns the proper partial path' do
      expect(invoice.to_partial_path).to eq "subscriber/invoices/invoice"
    end
  end

  context 'invoice which has discount in percent' do
    let(:invoice) { Invoice.new('in_3Eh5UIbuDVdhat') }

    it 'returns the correct discount amount' do
      expect(invoice.discount_amount).to eq 99.00
    end
  end

  describe '#line_items' do
    it 'returns line items for all the stripe invoice lines' do
      lines = [:subscription]
      stripe_invoice = stub('stripe_invoice', lines: lines)
      invoice = Invoice.new(stripe_invoice)

      stripe_line_items = stripe_invoice.lines

      line_items = stripe_line_items.map do |stripe_line_item|
        LineItem.new(stripe_line_item)
      end

      expect(invoice.line_items).to eq(line_items)
    end
  end
end
