require 'rails_helper'

feature 'An OAuth client authenticates', js: true do
  scenario 'via redirect' do
    create_client_app
    visit_client_app
    user = create(:subscriber)
    authorize_via_redirect(user)
    verify_signed_in_user_details_from_page(user)
  end

  scenario 'via redirect with GitHub' do
    create_client_app
    visit_client_app

    click_on 'Sign Into Learn'
    click_link 'with GitHub'

    user = User.find_by_email!(
      OmniAuth.config.mock_auth[:github]['info']['email']
    )

    expect(current_path).not_to eq dashboard_path
    verify_signed_in_user_details_from_page(user)
  end

  scenario 'via password' do
    create_client_app
    user = create(:subscriber)
    json = authorize_via_password(user)
    verify_signed_in_user_details json, user
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

  def authorize_via_redirect(user)
    click_on 'Sign Into Learn'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end

  def authorize_via_password(user)
    client = OAuth2::Client.new(
      FakeOauthClientApp.client_id,
      FakeOauthClientApp.client_secret,
      :site => FakeOauthClientApp.server_url
    )
    access_token = client.password.get_token(user.email, user.password)
    JSON.parse access_token.get(resource_owner_path).body
  end

  def verify_signed_in_user_details_from_page(user)
    json = JSON.parse(page.find('#data').text)
    verify_signed_in_user_details json, user
  end

  def verify_signed_in_user_details(json, checked_user)
    user = json['user']
    expect(user["email"]).to eq checked_user.email
  end
end
