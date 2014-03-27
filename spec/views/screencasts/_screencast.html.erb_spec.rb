require 'spec_helper'

describe 'shows/_screencast.html.erb' do
  it 'includes published episodes count' do
    screencast = create(:screencast)
    create_list(:video, 2, :published, watchable: screencast)
    create(:video, watchable: screencast)

    render 'screencasts/screencast', screencast: screencast

    expect(rendered).to include('2 videos')
  end
end
