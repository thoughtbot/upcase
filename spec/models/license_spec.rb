require "rails_helper"

describe License do
  it { should belong_to(:licenseable) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }
  it { should delegate(:github_username).to(:user) }
  it { should delegate(:user_email).to(:user).as(:email) }
  it { should delegate(:licenseable_name).to(:licenseable).as(:name) }

  context "#save" do
    it "tells its licenseable to fulfill" do
      licenseable = create(:product)
      licenseable.stubs(:fulfill)
      license = build(:license, licenseable: licenseable)

      license.save!

      expect(licenseable).to have_received(:fulfill).with(license.user)
    end
  end
end
