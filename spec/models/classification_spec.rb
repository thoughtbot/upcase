require "rails_helper"

describe Classification do
  it { should belong_to(:classifiable) }
  it { should belong_to(:topic) }

  context "validations" do
    it { should validate_uniqueness_of(:topic_id).scoped_to([:classifiable_id, :classifiable_type]) }
  end
end
