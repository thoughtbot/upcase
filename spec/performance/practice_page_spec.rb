require "rails_helper"

describe "/practice", type: :request do
  it "eager loads data" do
    user = create(:subscriber)

    expect { get practice_path(as: user) }.to eager_load { create_trail }
  end

  def create_trail
    trail = create(:trail, :published)
    create(:step, trail: trail)
  end
end
