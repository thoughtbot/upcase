require "spec_helper"

describe Forum do
  it "knows the url of the forum" do
    expect(Forum.url).to eq "https://forum.upcase.com/"
  end

  it "can give deep forum urls" do
    expect(Forum.url("test")).to eq "https://forum.upcase.com/test"
  end
end
