require "rails_helper"

describe Features::Mentor do
  describe "#fulfill" do
    it "assigns a mentor to the user if they don't have one already" do
      mentor = build_stubbed(:mentor)
      Mentor.stubs(:random).returns(mentor)
      user = build_stubbed(:user)
      user.stubs(:assign_mentor)

      Features::Mentor.new(user: user).fulfill

      expect(user).to have_received(:assign_mentor).with(mentor)
    end

    it "doesn't assign a new mentor if the user already has one" do
      user = build_stubbed(:user, :with_mentor)
      user.stubs(:assign_mentor)

      Features::Mentor.new(user: user).fulfill

      expect(user).to have_received(:assign_mentor).never
    end
  end

  describe "#unfulfill" do
    it "remove mentor for user" do
      user = build_stubbed(:user, :with_mentor)
      user.stubs(:assign_mentor).with(nil)
      mail = stub(deliver_now: true)
      DowngradeMailer.
        stubs(:notify_mentor).
        with(mentee_id: user.id, mentor_id: user.mentor_id).
        returns(mail)

      Features::Mentor.new(user: user).unfulfill

      expect(user).to have_received(:assign_mentor).with(nil)
      expect(DowngradeMailer).to have_received(:notify_mentor)
    end
  end
end
