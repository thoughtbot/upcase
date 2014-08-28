module Features
  class Mentor
    def initialize(user:)
      @user = user
    end

    def fulfill
      user.assign_mentor(mentor) unless user.mentor
    end

    def unfulfill
      user.assign_mentor(nil)
    end

    private

    attr_reader :user

    def mentor
      ::Mentor.random
    end
  end
end
