require 'spec_helper'

describe Classification do
  it { should belong_to(:classifiable) }
  it { should belong_to(:topic) }

  it "ensures uniqueness" do
    create(:classification)
    should validate_uniqueness_of(:classifiable_id).scoped_to([:topic_id, :classifiable_type])
  end
end
