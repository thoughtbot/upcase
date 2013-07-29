require 'spec_helper'

describe Paperclip::Id3 do
  it 'adds id3 tags to a new version of the given mp3' do
    file = episode_mp3_fixture
    episode = create(:episode)
    attachment = stub(instance: episode)
    processor = Paperclip::Id3.new(file, nil, attachment)

    mp3 = processor.make

    expect(mp3).not_to eq file
    Mp3Info.open(mp3) do |mp3|
      expect_v1_tags(episode, mp3)
      expect_v2_tags(episode, mp3)
      expect_cover_art(episode, mp3)
    end
  end

  it 'sets mp3 size and duration information on the episode' do
    episode = create(:episode)
    attachment = stub(instance: episode)
    processor = Paperclip::Id3.new(episode_mp3_fixture, nil, attachment)

    expect(episode.file_size).to be_nil
    expect(episode.duration).to be_nil

    mp3 = processor.make

    expect(episode.file_size).not_to be_nil
    expect(episode.duration).not_to be_nil
  end

  def expect_v1_tags(episode, mp3)
    expect(mp3.tag1.title).to eq episode.full_title
    expect(mp3.tag1.artist).to eq 'thoughtbot'
    expect(mp3.tag1.album).to eq episode.show.title.first(30)
    expect(mp3.tag1.year).to eq episode.published_on.year
  end

  def expect_v2_tags(episode, mp3)
    expect(mp3.tag2.TIT2).to eq episode.full_title
    expect(mp3.tag2.TALB).to eq episode.show.title
    expect(mp3.tag2.TCON).to eq 'Podcast'
    expect(mp3.tag2.TYER).to eq episode.published_on.year.to_s
    expect(mp3.tag2.PCST).to eq "\x00\x00\x00\x00"
    expect(mp3.tag2.TGID).to eq episode_url(episode)
    expect(mp3.tag2.WFED).to eq "\x00http://www.example.com/#{episode.show.to_param}.xml\x00"
    expect(mp3.tag2.WXXX).to eq "\x00\x00\x00#{episode_url(episode)}\00"
    expect(mp3.tag2.TDES).to eq "#{episode.description}\n\n#{episode.notes}"
    expect(mp3.tag2.TDRL).to eq episode.published_on.to_s
    expect(mp3.tag2.COMM).to eq episode.description

    %w(TPE1 TOPE TENC TPUB).each do |field|
      expect(mp3.tag2[field]).to eq 'thoughtbot'
    end
    expect(mp3.tag2.TCOP).to eq '2013 thoughtbot, inc.'
  end

  def expect_cover_art(episode, mp3)
    cover_image_path = File.join(Rails.root, 'app', 'assets', 'images', 'podcast', "#{episode.show.slug}-1400.jpg")
    expect(mp3.tag2.pictures[0].second).
      to eq File.new(cover_image_path, 'rb').read
  end

  def episode_url(episode)
    "http://www.example.com/#{episode.show.to_param}/#{episode.to_param}"
  end
end
