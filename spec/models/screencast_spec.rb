require 'spec_helper'

describe Screencast do
  it { should have_many(:videos) }

  it_behaves_like 'a class inheriting from Product'

  describe '#collection?' do
    it 'is a collection if there is more than one video' do
      screencast = create(:screencast)
      create(:video, watchable: screencast)
      create(:video, watchable: screencast)

      expect(screencast).to be_collection
    end

    it 'is not a collection of there is 1 video or less' do
      screencast = create(:screencast)

      expect(screencast).not_to be_collection

      create(:video, watchable: screencast)

      expect(screencast).not_to be_collection
    end
  end
end
