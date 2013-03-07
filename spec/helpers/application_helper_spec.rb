require 'spec_helper'

describe ApplicationHelper do
  describe 'show_account_links?' do
    it 'returns false when the controller is topics' do
      helper.stubs(:controller).returns(TopicsController.new)
      helper.show_account_links?.should == false
    end

    it 'returns true when the controller is not topics' do
      helper.stubs(:controller).returns(WorkshopsController.new)
      helper.show_account_links?.should == true
    end
  end
end
