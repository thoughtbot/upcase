require "rails_helper"

RSpec.describe Show do
  it_behaves_like "a class inheriting from Product"

  describe ".the_weekly_iteration" do
    it "finds the show named The Weekly Iteration" do
      show = create(:show, name: Show::THE_WEEKLY_ITERATION)

      result = Show.the_weekly_iteration

      expect(result).to eq show
    end
  end
end
