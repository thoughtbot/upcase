require "rails_helper"

describe Download do

  describe '#display_name' do
    it 'displays name with file name and size' do
      download = build_stubbed(:download,
                               download_file_name: 'file-name',
                               download_file_size: 100)

      expect(download.display_name).to eq("file-name (100 Bytes)")
    end
  end
end
