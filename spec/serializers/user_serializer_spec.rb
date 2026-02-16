require "rails_helper"

RSpec.describe UserSerializer do
  include Gravatarify::Helper

  it "serializes simple attributes" do
    user = build_stubbed(:user, :with_github)

    user_json = parse_serialized_json(user)

    expect(user_json["email"]).to eq user.email
    expect(user_json["first_name"]).to eq user.first_name
    expect(user_json["username"]).to eq user.github_username
    expect(user_json["id"]).to eq user.id
    expect(user_json["last_name"]).to eq user.last_name
    expect(user_json["avatar_url"]).to eq gravatar_url(user.email)
  end

  context "when the user has access to forum" do
    it "includes a key allowing forum access" do
      user = create(:user)

      user_json = parse_serialized_json(user)

      expect(user_json["has_forum_access"]).to be true
    end
  end

  context "when the user is an admin" do
    it "includes a key granting forum access" do
      user = create(:admin)

      user_json = parse_serialized_json(user)

      expect(user_json["has_forum_access"]).to be true
    end

    it "includes a key indicating they are an admin" do
      user = create(:admin)

      user_json = parse_serialized_json(user)

      expect(user_json["admin"]).to be true
    end
  end

  def parse_serialized_json(user)
    user_json = serialized_user(user).to_json
    JSON.parse(user_json)["user"]
  end

  def serialized_user(user)
    ActiveModelSerializers::SerializableResource.new(user)
  end
end
