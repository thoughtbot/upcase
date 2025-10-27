require "rails_helper"

RSpec.describe Teacher do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  [:name, :email, :bio].each do |attribute|
    describe "##{attribute}" do
      it "delegates to the user" do
        user = build_stubbed(:user)
        allow(user).to receive(attribute).and_return("text")
        teacher = build_stubbed(:teacher, user: user)

        teacher.send(attribute)

        expect(user).to have_received(attribute)
      end
    end
  end
end
