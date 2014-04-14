require 'spec_helper'

describe VideoPage do
  describe '#purchaseable' do
    it 'delegates to purchase' do
      purchaseable = stub('purchaseable')
      purchase = stub('purchase', purchaseable: purchaseable)

      result = create_video_page(purchase: purchase).purchaseable

      expect(result).to eq purchaseable
    end
  end

  describe '#collection?' do
    it 'delegates to purchaseable' do
      purchaseable = stub('purchaseable', collection?: true)
      purchase = stub('purchase', purchaseable: purchaseable)

      result = create_video_page(purchase: purchase).collection?

      expect(result).to be_true
    end
  end

  describe '#name' do
    it 'delegates to purchaseable' do
      purchaseable = stub('purchaseable', name: 'abc123')
      purchase = stub('purchase', purchaseable: purchaseable)

      name = create_video_page(purchase: purchase).name

      expect(name).to eq 'abc123'
    end
  end

  describe '#paid?' do
    it 'delegates to purchase' do
      purchase = stub('purchase', paid?: true)

      result = create_video_page(purchase: purchase)

      expect(result).to be_true
    end
  end

  describe '#title' do
    it 'delegates to video' do
      video = stub('video', title: 'abc123')

      title = create_video_page(video: video).title

      expect(title).to eq 'abc123'
    end
  end

  def create_video_page(options)
    purchase = options[:purchase] || stub('purchase')
    video = options[:video] || stub('video')
    VideoPage.new(purchase: purchase, video: video)
  end
end
