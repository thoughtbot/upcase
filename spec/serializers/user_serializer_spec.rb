require "rails_helper"

describe UserSerializer do
  include Gravatarify::Helper

  it 'serializes simple attributes' do
    user = build_stubbed(:user, :with_github)

    user_json = parse_serialized_json(user)

    expect(user_json['email']).to eq user.email
    expect(user_json['first_name']).to eq user.first_name
    expect(user_json['username']).to eq user.github_username
    expect(user_json['id']).to eq user.id
    expect(user_json['last_name']).to eq user.last_name
    expect(user_json['avatar_url']).to eq gravatar_url(user.email)
  end

  context 'when the user has an active subscription' do
    it 'includes a key indicating a subscription' do
      user = create(:subscriber)

      user_json = parse_serialized_json(user)

      expect(user_json["has_active_subscription"]).to be true
    end
  end

  context 'when the user does not have an active subscription' do
    it 'includes a key indicating no subscription' do
      user = build_stubbed(:user)

      user_json = parse_serialized_json(user)

      expect(user_json["has_active_subscription"]).to be false
    end
  end

  context 'when the user has subscription with access to forum' do
    it 'includes a key allowing forum access' do
      user = create(:subscriber)

      user_json = parse_serialized_json(user)

      expect(user_json["has_forum_access"]).to be true
    end
  end

  context 'when the user does not have an active subscription but is an admin' do
    it 'includes a key granting forum access' do
      user = create(:admin)

      user_json = parse_serialized_json(user)

      expect(user_json["has_forum_access"]).to be true
    end

    it 'includes a key indicating they are an admin' do
      user = create(:admin)

      user_json = parse_serialized_json(user)

      expect(user_json["admin"]).to be true
    end
  end

  def parse_serialized_json(user)
    JSON.parse(UserSerializer.new(user).to_json)['user']
  end
end
