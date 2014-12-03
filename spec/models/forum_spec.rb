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
end
