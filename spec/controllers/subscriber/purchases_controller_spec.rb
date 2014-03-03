require 'spec_helper'

describe Subscriber::PurchasesController do
  describe '#new when attempting to purchase without being signed in' do
    it 'redirects to sign in page' do
      workshop = build_stubbed(:workshop)

      get :new, workshop_id: workshop.id

      expect(response).to redirect_to sign_in_path
    end
  end
end
