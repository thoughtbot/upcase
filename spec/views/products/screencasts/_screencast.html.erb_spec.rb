require "rails_helper"

describe "products/screencasts/_screencast.html.erb" do
  it 'includes published episodes count' do
    screencast = build_stubbed(:screencast)
    create_list(:video, 2, :published, watchable: screencast)
    create(:video, watchable: screencast)

    render "products/screencasts/screencast", screencast: screencast

    expect(rendered).to include("2 videos")
  end
end
