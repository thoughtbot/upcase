require "rails_helper"

describe Teacher do
  it { should belong_to(:user) }
  it { should belong_to(:workshop) }

  [:name, :email, :bio].each do |attribute|
    describe "##{attribute}" do
      it 'delegates to the user' do
        user = build_stubbed(:user)
        user.stubs(attribute).returns('text')
        teacher = build_stubbed(:teacher, user: user)

        teacher.send(attribute)

        expect(user).to have_received(attribute)
      end
    end
  end
end
