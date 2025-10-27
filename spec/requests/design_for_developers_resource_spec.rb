require "rails_helper"

RSpec.describe "Design For Developers Resources" do
  it "handles a missing resource" do
    expect { get_missing_resource }.to raise_error(ActiveRecord::RecordNotFound)
  end

  def get_missing_resource
    get "/upcase/design-for-developers-resources/missing-resource"
  end
end
