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

  describe '.promotion_partial' do
    it 'returns the correct partial for a product' do
      product = create(:product)
      helper.promotion_partial(product).should == 'promoted_product'
    end

    it 'returns the correct partial for a workshop' do
      workshop = create(:workshop)
      helper.promotion_partial(workshop).should == 'promoted_workshop'
    end
  end
end
