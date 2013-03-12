require 'spec_helper'

describe WorkshopsController do
  context "show" do
    it "redirects to a user's purchase if the user has one" do
      user = create(:user)
      purchase = create(:section_purchase, user: user)
      sign_in_as user

      get :show, id: purchase.purchaseable.workshop.to_param

      expect(response).to redirect_to purchase_path(purchase)
    end

    it 'renders the show page if a user has not purchased' do
      user = create(:user)
      purchase = create(:section_purchase)
      sign_in_as user

      get :show, id: purchase.purchaseable.workshop.to_param

      expect(response).to render_template "show"
    end
  end
end
