require "rails_helper"

RSpec.describe "Vanity pages" do
  it "raise a deprecation warning" do
    expect {
      get vanity_index_path
    }.to output(/^DEPRECATION WARNING/).to_stderr
  end
end
