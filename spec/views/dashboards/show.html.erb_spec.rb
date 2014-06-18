require 'spec_helper'

describe 'dashboards/show.html' do
  it 'renders without access to learn repo if not part of subscription' do
    render_show

    expect(rendered).not_to have_content('Learn Repo')
  end

  it 'renders with access to learn repo if part of subscription' do
    render_show source_code: true

    expect(rendered).to have_content('Learn Repo')
  end

  it 'renders without access to learn live if not part of subscription' do
    render_show

    expect(rendered).not_to have_content('Learn Live')
  end

  it 'renders with access to learn live if part of subscription' do
    render_show office_hours: true

    expect(rendered).to have_content('Learn Live')
  end

  it 'renders without access to forum if not part of subscription' do
    render_show

    expect(rendered).not_to have_content('Forum')
  end

  it 'renders with access to forum if part of subscription' do
    render_show forum: true

    expect(rendered).to have_content('Forum')
  end

  it 'renders with access to workshops and shows' do
    render_show shows: true, workshops: true, exercises: true

    expect(rendered).not_to have_content('locked')
  end

  it 'renders with access to shows but without access to workshops' do
    render_show shows: true, workshops: true

    expect(rendered).to have_content('Exercises are locked')
  end

  it 'renders with access to shows but without access to workshops' do
    render_show shows: true

    expect(rendered).to have_content('Exercises and workshops are locked')
  end

  it 'renders without access to shows or workshops' do
    render_show

    expect(rendered).
      to have_content('Exercises, workshops, and shows are locked')
  end

  def render_show(options = {})
    options = default_options.merge(options)
    view_stubs(:current_user).returns(build_stubbed(:user))
    options.each do |feature, value|
      view_stubs(:current_user_has_access_to?).with(feature).returns(value)
    end
    view_stubs(:current_user_has_access_to_shows?).
      returns(options[:shows])
    assign :catalog, Catalog.new
    render template: 'dashboards/show'
  end

  def default_options
    {
      source_code: false,
      office_hours: false,
      forum: false,
      shows: false,
      workshops: false,
      exercises: false
    }
  end
end
