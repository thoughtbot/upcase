require 'spec_helper'

describe VideoPage do
  describe '#purchaseable' do
    it 'delegates to purchase' do
      purchase = stub(:purchase)
      purchase.stubs(purchaseable: nil)
      video_page = VideoPage.new(purchase: purchase)

      video_page.purchaseable

      expect(purchase).to have_received(:purchaseable)
    end
  end
end
