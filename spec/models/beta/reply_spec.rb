require "rails_helper"

describe Beta::Reply do
  it { is_expected.to belong_to(:offer) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:offer_id) }
  it { is_expected.to validate_presence_of(:user_id) }
end
