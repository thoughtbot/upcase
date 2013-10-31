require 'spec_helper'

describe AuthHashService, '#find_or_create_user_from_auth_hash' do
  it 'creates a user using nickname as a name when name is blank in auth_hash' do
    hash = auth_hash('info' => {'name' => nil,
                                'email' => 'user@example.com',
                                'nickname' => 'thoughtbot'})
    user = AuthHashService.new(hash).find_or_create_user_from_auth_hash

    expect(user).to be_persisted
    expect(user.name).to eq 'thoughtbot'
    expect(user.github_username).to eq 'thoughtbot'
  end

  it 'creates a new user when no matching user' do
    stub_team_member false

    user = AuthHashService.new(auth_hash).find_or_create_user_from_auth_hash

    expect(user).to be_persisted
    expect(user.name).to eq 'Test User'
    expect(user.email).to eq 'user@example.com'
    expect(user.github_username).to eq 'thoughtbot'
    expect(user.auth_provider).to eq 'github'
    expect(user.auth_uid).to eq 1
    expect(user).not_to be_admin
  end

  it 'creates a new admin when no matching user from our organization' do
    stub_team_member true

    user = AuthHashService.new(auth_hash).find_or_create_user_from_auth_hash

    expect(user).to be_admin
  end

  context 'with an existing user' do
    it 'finds the user' do
      existing_user = create(:user, auth_provider: 'github', auth_uid: 1)

      expect(existing_user).to eq AuthHashService.new(auth_hash).find_or_create_user_from_auth_hash
    end
  end

  def stub_team_member(return_value)
    client = stub('github_client')
    client.
      stubs(:team_member?).
      with(AuthHashService::THOUGHTBOT_GITHUB_TEAM_ID, 'thoughtbot').
      returns(return_value)
    Octokit::Client.
      stubs(:new).
      with(login: GITHUB_USER, password: GITHUB_PASSWORD).
      returns(client)
  end

  def auth_hash(options = {})
    {
      'provider' => 'github',
      'uid' => 1,
      'info' => {
        'email' => 'user@example.com',
        'name' => 'Test User',
        'nickname' => 'thoughtbot',
      }
    }.merge(options)
  end
end
