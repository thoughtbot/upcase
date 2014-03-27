require 'spec_helper'

describe 'shows/_show.html.erb' do
  it 'includes episodes count' do
    show = create(:show)
    create_list(:video, 2, watchable: show)

    render 'shows/show', show: show

    expect(rendered).to include('2 episodes')
  end
end
