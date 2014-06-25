require 'spec_helper'

describe SubscriptionsController do
  describe "#new" do
    it "assigns featured individual plans in order" do
      get :new

      expect(assigns(:plans)).
        to find_relation(IndividualPlan.featured.active.ordered)
    end
  end
end
