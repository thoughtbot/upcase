module Features
  class Mentor
    def initialize(user:)
      @user = user
    end

    def fulfill
      user.assign_mentor(mentor) unless user.mentor
    end

    def unfulfill
      notify_mentor
      user.assign_mentor(nil)
    end

    private

    attr_reader :user

    def notify_mentor
      DowngradeMailer.
        delay.
        notify_mentor(mentee_id: user.id, mentor_id: user.mentor_id)
    end

    def mentor
      ::Mentor.random
    end
  end
end
