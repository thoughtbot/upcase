require 'spec_helper'

describe Classification do
  it { should belong_to(:classifiable) }
  it { should belong_to(:topic) }

  it { should allow_mass_assignment_of(:classifiable_id) }
  it { should allow_mass_assignment_of(:classifiable_type) }
  it { should allow_mass_assignment_of(:classifiable) }
  it { should allow_mass_assignment_of(:topic_id) }

  it "ensures uniqueness" do
    create(:classification)
    should validate_uniqueness_of(:classifiable_id).scoped_to([:topic_id, :classifiable_type])
  end
end

describe Classification, "callback" do
  let(:topic) { create(:topic) }
  let(:article) { create(:article) }
  it "updates topic count" do
    topic.articles << article
    Topic.first.count.should == 1
  end
end


