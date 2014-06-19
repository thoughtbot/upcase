require 'spec_helper'

describe UserSerializer do
  include Gravatarify::Helper

  it 'serializes simple attributes' do
    user = build_stubbed(:user, :with_github)

    user_json = parse_serialized_json(user)

    user_json['email'].should == user.email
    user_json['first_name'].should == user.first_name
    user_json['username'].should == user.github_username
    user_json['id'].should == user.id
    user_json['last_name'].should == user.last_name
    user_json['avatar_url'].should == gravatar_url(user.email)
  end

  context 'with public keys' do
    it 'serializes public keys as an array of strings' do
      public_keys = [
        build_stubbed(:public_key, data: 'key-one'),
        build_stubbed(:public_key, data: 'key-two')
      ]
      user = build_stubbed(:user, public_keys: public_keys)

      user_json = parse_serialized_json(user)

      user_json['public_keys'].should match_array(%w(key-one key-two))
    end
  end

  context 'when the user has an active subscription' do
    it 'includes a key indicating a subscription' do
      user = create(:subscriber)

      user_json = parse_serialized_json(user)

      user_json['has_active_subscription'].should be_true
    end
  end

  context 'when the user does not have an active subscription' do
    it 'includes a key denying forum access' do
      user = build_stubbed(:user)

      user_json = parse_serialized_json(user)

      user_json['has_forum_access'].should be_false
    end

    it 'includes a key indicating no subscription' do
      user = build_stubbed(:user)

      user_json = parse_serialized_json(user)

      user_json['has_active_subscription'].should be_false
    end
  end

  context 'when the user has subscription without access to forum' do
    it 'includes a key denying forum access' do
      user = create(:user, :with_basic_subscription).reload

      user_json = parse_serialized_json(user)

      user_json['has_forum_access'].should be_false
    end
  end

  context 'when the user has subscription with access to forum' do
    it 'includes a key allowing forum access' do
      user = create(:subscriber)

      user_json = parse_serialized_json(user)

      user_json['has_forum_access'].should be_true
    end
  end

  context 'when the user does not have an active subscription but is an admin' do
    it 'includes a key granting forum access' do
      user = create(:admin)

      user_json = parse_serialized_json(user)

      user_json['has_forum_access'].should be_true
    end

    it 'includes a key indicating they are an admin' do
      user = create(:admin)

      user_json = parse_serialized_json(user)

      user_json['admin'].should be_true
    end
  end

  def parse_serialized_json(user)
    JSON.parse(UserSerializer.new(user).to_json)['user']
  end
end
