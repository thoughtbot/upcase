require 'spec_helper'

describe Mentor do
  it { should have_many(:mentees) }

  describe '.featured' do
    it 'executes queries on the relation' do
      mentors = stub('mentors', :sample)
      Mentor.stubs(all: mentors)

      Mentor.featured

      expect(mentors).to have_received(:sample).with(Mentor::NUMBER_OF_MENTORS_TO_FEATURE)
    end
  end

  describe '.find_or_sample' do
    it 'returns a mentor for the given id' do
      mentor = create(:mentor)

      expect(Mentor.find_or_sample(mentor.id)).to eq mentor
    end

    it 'returns a random mentor if one cannot be found with the given id' do
      mentor = create(:mentor)

      expect(Mentor.find_or_sample(nil)).to eq mentor
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
      active = create(:subscriber)
      inactive = create(:user, :with_inactive_subscription)
      without_mentoring = create(:user, :with_downgraded_subscription)
      mentor.mentees = [active, inactive, without_mentoring]

      expect(mentor.active_mentees).to eq [active]
    end
  end

  describe '#active_mentee_count' do
    it 'returns the list of active mentees' do
      mentor = create(:mentor)
      mentor.mentees = [
        create(:subscriber),
        create(:subscriber)
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
