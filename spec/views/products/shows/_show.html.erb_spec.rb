require "rails_helper"

describe "products/shows/_show.html.erb" do
  it 'includes published episodes count' do
    show = build_stubbed(:show)
    create_list(:video, 2, :published, watchable: show)
    create(:video, watchable: show)

    render "products/shows/show", show: show

    expect(rendered).to include("2 episodes")
  end
end
