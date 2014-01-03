require 'spec_helper'

describe Subscriber::InvoicesController do
  context 'show' do
    it 'does not allow user to view invoice that does not belongs to them' do
      user = build_stubbed(:user)
      invoice = stub(id: 'abc123', user: build_stubbed(:user))
      SubscriptionInvoice.stubs(new: invoice)
      sign_in_as user

      expect { get :show, id: invoice.id }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
