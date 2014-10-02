require "rails_helper"

describe Step do
  it { should belong_to(:exercise) }
  it { should belong_to(:trail) }

  context "with an existing step" do
    before { create(:step) }
    it { should validate_uniqueness_of(:position).scoped_to(:trail_id) }
  end
end
