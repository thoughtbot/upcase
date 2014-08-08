require "rails_helper"

describe Mentor do
  it { should have_many(:mentees) }
  it { should validate_presence_of(:user) }

  describe '.promoted' do
    it 'executes queries on the relation' do
      mentors = stub('mentors', :sample)
      Mentor.stubs(accepting_new_mentees: mentors)

      Mentor.promoted

      expect(mentors).
        to have_received(:sample).with(Mentor::NUMBER_OF_MENTORS_TO_PROMOTE)
    end
  end

  describe '.random' do
    it 'returns a random mentor' do
      mentor = create(:mentor, accepting_new_mentees: true)

      expect(Mentor.random).to eq mentor
    end

    it 'does not return unavailable mentors when sampling' do
      create(:mentor, accepting_new_mentees: false)

      expect(Mentor.random).to be_nil
    end
  end

  describe '#availability' do
    it "has a default" do
      mentor = Mentor.new

      expect(mentor.availability).to eq '11am to 5pm on Fridays'
    end
  end

  describe '#active_mentees' do
    it 'returns the list of active mentees' do
      mentor = create(:mentor)
      active = create(:subscriber, :includes_mentor)
      inactive = create(:user, :with_inactive_subscription)
      without_mentoring = create(:basic_subscriber)
      mentor.mentees = [active, inactive, without_mentoring]

      expect(mentor.active_mentees).to eq [active]
    end

    it 'eager loads mentees' do
      mentor = create(:mentor)

      expect { mentor.reload.active_mentees }.
        to eager_load { create(:subscriber, :includes_mentor, mentor: mentor) }
    end
  end

  describe '#active_mentee_count' do
    it 'returns the list of active mentees' do
      mentor = create(:mentor)
      mentor.mentees = [
        create(:subscriber, :includes_mentor),
        create(:subscriber, :includes_mentor)
      ]

      expect(mentor.active_mentee_count).to eq 2
    end
  end

  [:name, :first_name, :email, :github_username, :bio].each do |attribute|
    describe "##{attribute}" do
      it 'delegates the user' do
        user = build_stubbed(:user)
        user.stubs(attribute).returns('text')
        mentor = build_stubbed(:mentor, user: user)

        mentor.send(attribute)

        expect(user).to have_received(attribute)
      end
    end
  end
end
