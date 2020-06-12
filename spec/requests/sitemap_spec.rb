require "rails_helper"

describe "The sitemap" do
  it "responds with an XML sitemap" do
    create(:show, name: Show::THE_WEEKLY_ITERATION)

    get "/upcase/sitemap.xml", params: { format: :xml }

    expect(response).to be_successful
    expect(response.media_type).to eq("application/xml")
  end
end
