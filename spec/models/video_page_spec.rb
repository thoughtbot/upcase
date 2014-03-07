require 'spec_helper'

describe VideoPage do
  let(:purchase) { stub(:purchase) }
  let(:purchaseable) { stub(:purchaseable) }
  let(:video) { stub(:video) }
  let(:video_page) { VideoPage.new(purchase: purchase, video: video) }

  describe '#purchaseable' do
    it 'delegates to purchase' do
      purchase.stubs(:purchaseable)

      video_page.purchaseable

      expect(purchase).to have_received(:purchaseable)
    end
  end

  describe '#collection?' do
    it 'delegates to purchaseable' do
      purchaseable.stubs(:collection?)
      purchase.stubs(purchaseable: purchaseable)

      video_page.collection?

      expect(purchaseable).to have_received(:collection?)
    end
  end

  describe '#name' do
    it 'delegates to purchaseable' do
      purchaseable.stubs(:name)
      purchase.stubs(purchaseable: purchaseable)

      video_page.name

      expect(purchaseable).to have_received(:name)
    end
  end

  describe '#to_aside_partial' do
    it 'delegates to purchaseable' do
      purchaseable.stubs(:to_aside_partial)
      purchase.stubs(purchaseable: purchaseable)

      video_page.to_aside_partial

      expect(purchaseable).to have_received(:to_aside_partial)
    end
  end

  describe '#paid?' do
    it 'delegates to purchase' do
      purchase.stubs(:paid?)

      video_page.paid?

      expect(purchase).to have_received(:paid?)
    end
  end

  describe '#video_title' do
    it 'delegates to video' do
      video.stubs(:title)

      video_page.video_title

      expect(video).to have_received(:title)
    end
  end
end
