require 'spec_helper'

describe UserSerializer do
  it 'serializes simple attributes' do
    user = build_stubbed(:user)

    user_json = parse_serialized_json(user)

    user_json['id'].should == user.id
    user_json['first_name'].should == user.first_name
    user_json['last_name'].should == user.last_name
    user_json['email'].should == user.email
  end

  context 'when the user has an active subscription' do
    it 'includes a key granting forum access' do
      user = create(:user, :with_subscription)

      user_json = parse_serialized_json(user)

      user_json['has_forum_access'].should be_true
    end
  end

  context 'when the user does not have an active subscription' do
    it 'includes a key denying forum access' do
      user = build_stubbed(:user)

      user_json = parse_serialized_json(user)

      user_json['has_forum_access'].should be_false
    end
  end

  def parse_serialized_json(user)
    JSON.parse(UserSerializer.new(user).to_json)['user']
  end
end
