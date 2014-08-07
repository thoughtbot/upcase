require "spec_helper"

describe License, :type => :model do
  it { should belong_to(:licenseable) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }
  it { should delegate(:github_username).to(:user) }
  it { should delegate(:user_email).to(:user).as(:email) }
  it { should delegate(:licenseable_name).to(:licenseable).as(:name) }

  context "#status" do
    it "returns in-progress when it ends today" do
      workshop = create(:workshop, length_in_days: 5)
      Timecop.travel(5.days.ago) do
        @license = create_license_from_licenseable(workshop)
      end

      expect(@license.status).to eq "in-progress"
    end

    it "returns in-progress when it ends in future" do
      workshop = create(:workshop, length_in_days: 5)
      license = create_license_from_licenseable(workshop)

      expect(license.status).to eq "in-progress"
    end

    it "returns complete when already ended" do
      workshop = create(:workshop, length_in_days: 5)

      Timecop.travel(6.days.ago) do
        @license = create_license_from_licenseable(workshop)
      end

      expect(@license.status).to eq "complete"
    end
  end

  context "#save" do
    it "tells its licenseable to fulfill" do
      licenseable = create(:book)
      licenseable.stubs(:fulfill)
      license = build(:license, licenseable: licenseable)

      license.save!

      expect(licenseable).
        to have_received(:fulfill).with(license, license.user)
    end
  end
end

describe License, "#starts_on", :type => :model do
  it "gets the starts_on from it's licenseable and it's own created_at" do
    created_at = 1.day.ago
    product = build(:product)
    product.stubs(:starts_on)
    license = build(:license, licenseable: product, created_at: created_at)

    license.starts_on

    expect(product).to have_received(:starts_on).with(created_at.to_date)
  end
end

describe License, "#ends_on", :type => :model do
  it "gets the starts_on from it's licenseable and it's own created_at" do
    created_at = 1.day.ago
    product = build(:product)
    product.stubs(:ends_on)
    license = build(:license, licenseable: product, created_at: created_at)

    license.ends_on

    expect(product).to have_received(:ends_on).with(created_at.to_date)
  end
end

describe License, "#active?", :type => :model do
  it "is true when today is between start and end" do
    product = build(:product)
    product.stubs(starts_on: Date.yesterday, ends_on: 4.days.from_now.to_date)
    license = build(:license, licenseable: product, created_at: Time.zone.today)

    Timecop.freeze(Time.zone.today) do
      expect(license).to be_active
    end

    Timecop.freeze(6.days.from_now) do
      expect(license).not_to be_active
    end
  end
end
