class AuthHashService
  THOUGHTBOT_GITHUB_TEAM_ID = 3675

  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def find_or_create_user_from_auth_hash
    find_by_auth_hash ||
      find_by_github ||
      find_by_email ||
      create_from_auth_hash
  end

  private

  attr_accessor :auth_hash

  def find_by_github
    user = User.find_by(github_username: auth_hash["info"]["nickname"])
    update_provider_info(user)
    user
  end

  def find_by_email
    user = User.find_by(email: auth_hash["info"]["email"])
    update_provider_info(user)
    user
  end

  def find_by_auth_hash
    User.find_by(auth_provider: auth_hash['provider'], auth_uid: auth_hash['uid'])
  end

  def create_from_auth_hash
    create_user.tap do |user|
      promote_thoughtbot_employee_to_admin(user)
      track_account_created(user)
    end
  end

  def update_provider_info(user)
    if user
      user.update_attributes(
        auth_provider: auth_hash["provider"],
        auth_uid: auth_hash["uid"]
      )
    end
  end

  def create_user
    User.create(
      auth_provider: auth_hash['provider'],
      auth_uid: auth_hash['uid'],
      name: name,
      email: auth_hash['info']['email'],
      github_username: auth_hash['info']['nickname']
    )
  end

  def name
    auth_hash['info']['name'] || auth_hash['info']['nickname']
  end

  def promote_thoughtbot_employee_to_admin(user)
    if octokit_client.team_member?(THOUGHTBOT_GITHUB_TEAM_ID, user.github_username)
      user.admin = true
      user.save!
    end
  end

  def track_account_created(user)
    Analytics.new(user).track_account_created
  end

  def octokit_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
