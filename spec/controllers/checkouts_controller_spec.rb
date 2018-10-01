require "rails_helper"

describe CheckoutsController do
  include StubCurrentUserHelper

  describe "#new" do
    it "redirects to the sign_in path" do
      get :new, params: { plan: stub_valid_sku }

      expect(response).to redirect_to sign_in_path
    end
  end

  describe "#create" do
    it "redirects to the sign_in path" do
      post :create, params: { plan: stub_valid_sku }

      expect(response).to redirect_to sign_in_path
    end
  end

  def stub_valid_sku
    stub_plan_by_sku.sku
  end

  def stub_plan_by_sku(*attributes)
    build_stubbed(:plan, *attributes).tap do |plan|
      allow(Plan).to receive(:find_by).with(sku: plan.sku).and_return(plan)
    end
  end
end
