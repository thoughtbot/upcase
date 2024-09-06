class AuthHashService
  THOUGHTBOT_GITHUB_TEAM_ID = 3675

  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def find_or_create_user_from_auth_hash
    user_from_auth_hash ||
      user_from_github ||
      user_from_email ||
      create_from_auth_hash
  end

  private

  attr_accessor :auth_hash

  def user_from_auth_hash
    User.find_by(
      auth_provider: auth_hash["provider"],
      auth_uid: auth_hash["uid"]
    )
  end

  def user_from_github
    github_user.tap do |user|
      update_provider_info(user)
    end
  end

  def user_from_email
    email_user.tap do |user|
      update_provider_info(user)
    end
  end

  def create_from_auth_hash
    create_user.tap do |user|
      if user.persisted?
        promote_thoughtbot_employee_to_admin(user)
      end
    end
  end

  def update_provider_info(user)
    user&.update(
      auth_provider: auth_hash["provider"],
      auth_uid: auth_hash["uid"]
    )
  end

  def github_user
    User.find_by(github_username: auth_info["nickname"])
  end

  def email_user
    User.find_by(email: auth_info["email"])
  end

  def create_user
    User.create(
      auth_provider: auth_hash["provider"],
      auth_uid: auth_hash["uid"],
      name: name,
      email: auth_info["email"],
      github_username: auth_info["nickname"]
    )
  end

  def name
    auth_info["name"] || auth_info["nickname"]
  end

  def auth_info
    auth_hash.fetch("info", {})
  end

  def promote_thoughtbot_employee_to_admin(user)
    if github_user_on_thoughtbot_team?(user)
      user.admin = true
      user.save!
    end
  end

  def github_user_on_thoughtbot_team?(user)
    octokit_client.team_member?(
      THOUGHTBOT_GITHUB_TEAM_ID,
      user.github_username
    )
  end

  def octokit_client
    Octokit::Client.new(
      access_token: GITHUB_ACCESS_TOKEN
    )
  end
end
