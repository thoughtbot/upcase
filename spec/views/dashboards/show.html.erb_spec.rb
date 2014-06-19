require 'spec_helper'

describe 'dashboards/show.html' do
  ENV['LEARN_REPO_URL'] = 'learn_repo_url'

  context 'when a user does not have access to the learn repo' do
    it 'renders without a link to learn repo' do
      render_show

      expect(rendered).
        not_to have_css("a[href='learn_repo_url']")
      expect(rendered).to have_css("a[href='#{edit_subscription_path}']")
    end
  end

  context 'when a user has access to the learn repo' do
    it 'renders with a link to learn repo' do
      render_show source_code: true

      expect(rendered).
        to have_css("a[href='learn_repo_url']")
    end
  end

  context 'when a user does not have access to learn live' do
    it 'renders without a link to learn live' do
      render_show

      expect(rendered).not_to have_css("a[href='#{OfficeHours.url}']")
      expect(rendered).to have_css("a[href='#{edit_subscription_path}']")
    end
  end

  context 'when a user has access to learn live' do
    it 'renders with a link to learn live' do
      render_show office_hours: true

      expect(rendered).to have_css("a[href='#{OfficeHours.url}']")
    end
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
