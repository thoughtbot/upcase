require 'spec_helper'

describe SubscriptionsController do
  describe '#new' do
    it 'assigns featured team plans in order' do
      mentor = build_stubbed(:mentor)
      Mentor.stubs(:find_or_sample).returns(mentor)

      get :new

      expect(assigns(:team_plans)).
        to find_relation(Teams::TeamPlan.featured.ordered)
    end
  end
end
