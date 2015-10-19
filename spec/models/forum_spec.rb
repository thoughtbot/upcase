require "spec_helper"

describe Forum do
  it "knows the url of the forum" do
    ClimateControl.modify FORUM_URL: "https://forum.example.com" do
      expect(Forum.url).to eq "https://forum.example.com/"
    end
  end

  it "can give deep forum urls" do
    ClimateControl.modify FORUM_URL: "https://forum.example.com" do
      expect(Forum.url("test")).to eq "https://forum.example.com/test"
    end
  end

  it "knows the sso url of the forum" do
    ClimateControl.modify FORUM_URL: "https://forum.example.com" do
      expect(Forum.sso_url).to eq "https://forum.example.com/session/sso_login"
    end
  end

  it "is not accessible without a subscription" do
    expect(Forum.accessible_without_subscription?).to eq false
  end
end
