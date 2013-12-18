require 'spec_helper'

describe 'dashboards/show.html' do
  it 'renders with access to workshops and shows' do
    render_show shows: true, workshops: true

    expect(rendered).not_to have_content('locked')
  end

  it 'renders with access to shows but without access to workshops' do
    render_show shows: true, workshops: false

    expect(rendered).to have_content('Workshops are locked')
  end

  it 'renders without access to shows or workshops' do
    render_show shows: false, workshops: false

    expect(rendered).to have_content('Workshops and shows are locked')
  end

  def render_show(options)
    view_stubs(:current_user).returns(build_stubbed(:user))
    view_stubs(:current_user_has_access_to_workshops?).
      returns(options[:workshops])
    view_stubs(:current_user_has_access_to_shows?).
      returns(options[:shows])
    assign :catalog, Catalog.new
    render template: 'dashboards/show'
  end
end
