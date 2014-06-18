require 'spec_helper'

describe 'dashboards/show.html' do
  it 'renders with access to workshops and shows' do
    render_show shows: true, workshops: true, exercises: true

    expect(rendered).not_to have_content('locked')
  end

  it 'renders with access to shows but without access to workshops' do
    render_show shows: true, workshops: true, exercises: false

    expect(rendered).to have_content('Exercises are locked')
  end

  it 'renders with access to shows but without access to workshops' do
    render_show shows: true, workshops: false, exercises: false

    expect(rendered).to have_content('Exercises and workshops are locked')
  end

  it 'renders without access to shows or workshops' do
    render_show shows: false, workshops: false, exercises: false

    expect(rendered).
      to have_content('Exercises, workshops, and shows are locked')
  end

  def render_show(options)
    view_stubs(:current_user).returns(build_stubbed(:user))
    view_stubs(:current_user_has_access_to_exercises?).
      returns(options[:exercises])
    view_stubs(:current_user_has_access_to_workshops?).
      returns(options[:workshops])
    view_stubs(:current_user_has_access_to_shows?).
      returns(options[:shows])
    assign :catalog, Catalog.new
    render template: 'dashboards/show'
  end
end
