require "rails_helper"

RSpec.describe "Design For Developers Resources" do
  it "handles a missing resource" do
    get "/upcase/design-for-developers-resources/missing-resource"

    expect(response).to have_http_status(:not_found)
  end
end
