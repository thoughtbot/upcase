require 'spec_helper'

describe TopicsHelper, "#format_content" do
  subject do
    helper.format_content "<p>hello</p>#{'a' * 900}"
  end

  it "strips tags and truncates" do
    subject.should_not =~ /\<p\>/
    subject.length.should == 300
  end
end
