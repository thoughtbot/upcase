require 'spec_helper'

describe ApplicationHelper, 'show_account_links?' do
  it 'returns false when the controller is topics' do
    helper.stubs(:controller).returns(TopicsController.new)
    helper.show_account_links?.should == false
  end

  it 'returns true when the controller is not topics' do
    helper.stubs(:controller).returns(CoursesController.new)
    helper.show_account_links?.should == true
  end
end

describe ApplicationHelper, 'shorten_by_char' do
  it "returns correct shortened version of sentences" do
    helper.shorten_by_char("This is a test", 5).should == "This"
    helper.shorten_by_char("This is a test", 6).should == "This"
    helper.shorten_by_char("This is a test", 7).should == "This is"
    helper.shorten_by_char("This is. a test", 8).should == "This is."
  end
end

describe ApplicationHelper, 'shorten_by_word' do
  it "returns correct shortened version of sentences" do
    helper.shorten_by_word("This is a test", 1).should == "This"
    helper.shorten_by_word("This is a test", 2).should == "This is"
    helper.shorten_by_word("This is a test", 3).should == "This is a"
    helper.shorten_by_word("This is. a test", 4).should == "This is. a test"
  end
end
