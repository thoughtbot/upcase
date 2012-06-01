require 'spec_helper'

describe Author do
  context 'associations' do
    it { should have_many(:articles) }
  end

  context 'active_authorizer' do
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:tumblr_user) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  context 'validations' do
    it { should validate_presence_of(:tumblr_user_name) }

    context 'uniqueness' do
      before do
        create :author
      end

      it { should validate_uniqueness_of(:tumblr_user_name) }
    end
  end
end
