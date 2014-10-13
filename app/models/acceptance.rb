class Acceptance
  include ActiveModel::Model

  attr_reader :invitation

  delegate :errors, :github_username, :name, :password, to: :user

  validates :github_username, presence: true
  validate :password_if_user_exists, if: :existing_user
  validate :unused_invitation

  def initialize(invitation:, current_user: nil, attributes: {})
    @current_user = current_user
    @invitation = invitation
    email = (@current_user || @invitation).email
    @attributes = attributes.merge(email: email)
  end

  def save
    if valid? && user.save
      @invitation.accept(user)
      true
    else
      false
    end
  end

  def valid?(context = nil)
    super(context) && user.valid?(context)
  end

  def existing_user
    @existing_user ||= @current_user || @invitation.user_by_email
  end

  def user
    @user ||= existing_user_with_github || new_user
  end

  private

  def password_if_user_exists
    unless user.authenticated?(@attributes[:password])
      errors.add :password, "password is incorrect"
    end
  end

  def existing_user_with_github
    if existing_user && existing_user.github_username.nil?
      existing_user.update(github_username: @attributes[:github_username])
    end
    existing_user
  end

  def new_user
    User.new(@attributes)
  end

  def unused_invitation
    if invitation.accepted?
      errors.add :invitation, "has already been accepted"
    end
  end
end
