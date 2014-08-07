require "rails_helper"

describe Show, type: :model do
  it_behaves_like 'a class inheriting from Product'

  it { should have_many(:videos).dependent(:destroy) }

  describe '.the_weekly_iteration' do
    it 'finds the show named The Weekly Iteration' do
      show = create(:show, name: Show::THE_WEEKLY_ITERATION)

      result = Show.the_weekly_iteration

      expect(result).to eq show
    end
  end
end
