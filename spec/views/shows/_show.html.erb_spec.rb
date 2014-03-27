require 'spec_helper'

describe 'shows/_show.html.erb' do
  it 'includes published episodes count' do
    show = create(:show)
    create_list(:video, 2, watchable: show)
    create(:video, :unpublished, watchable: show)

    render 'shows/show', show: show

    expect(rendered).to include('2 episodes')
  end
end
