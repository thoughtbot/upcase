module Teams
  class Acceptance
    include ActiveModel::Model

    attr_reader :invitation, :user

    delegate :errors, :github_username, :name, :password, to: :user

    validates :github_username, presence: true
    validate :unused_invitation

    def initialize(invitation, attributes)
      @invitation = invitation
      @user = User.new(attributes.merge(email: invitation.email))
    end

    def save
      if valid? && @user.save
        @invitation.accept(@user)
        true
      else
        false
      end
    end

    def valid?(context = nil)
      super(context) && @user.valid?(context)
    end

    private

    def unused_invitation
      if invitation.accepted?
        errors.add :invitation, 'has already been accepted'
      end
    end
  end
end
