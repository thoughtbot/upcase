require 'spec_helper'

feature 'An OAuth client authenticates', js: true do
  scenario 'successfully' do
    create_client_app
    visit_client_app
    authorize_via_oauth
    verify_signed_in
    verify_prime_flag_included_in_user_details
  end

  def create_client_app
    using_session 'admin' do
      admin = create(:admin)
      visit oauth_applications_path(as: admin)
      click_on 'New Application'
      fill_in 'Name', with: 'Fake'
      fill_in 'Redirect uri', with: FakeOauthClientApp.redirect_uri
      click_on 'Submit'

      FakeOauthClientApp.client_id = find('#application_id').text
      FakeOauthClientApp.client_secret = find('#secret').text

      server_url = URI.parse(page.current_url).merge('/').to_s
      FakeOauthClientApp.server_url = server_url
    end
  end

  def visit_client_app
    visit FakeOauthClientApp.client_url + '/fake_oauth_client_app'
  end

  def authorize_via_oauth
    user = create(:user)
    click_on 'Sign Into Learn'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'
    click_on 'Authorize'
  end

  def verify_signed_in
    user = User.last
    page.body.should include user.email
  end

  def verify_prime_flag_included_in_user_details

    puts page.body
  end
end
