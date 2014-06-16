require 'spec_helper'

describe SubscriptionsController do
  describe '#new' do
    it 'assigns featured team plans in order' do
      get :new

      expect(assigns(:team_plans)).
        to find_relation(Teams::TeamPlan.featured.ordered)
    end
  end
end
