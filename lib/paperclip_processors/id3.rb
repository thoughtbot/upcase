require 'mp3info'

module Paperclip
  class Id3 < Processor
    include Rails.application.routes.url_helpers

    class InstanceNotGiven < ArgumentError; end

    def initialize(file, options = {}, attachment = nil)
      super
      @file = file
      @instance = attachment.instance
      @current_format = File.extname(@file.path)
      @basename = File.basename(@file.path, @current_format)
    end

    def make
      mp3_file = make_temp_mp3
      set_id3_tags(mp3_file)
      extract_mp3_info(mp3_file)
      mp3_file
    end

    private

    def make_temp_mp3
      @file.rewind
      dst = Tempfile.new([@basename, @current_format].compact.join("."))
      dst << File.read(@file.path)
      dst.flush
      dst
    end

    def set_id3_tags(mp3_file)
      Mp3Info.open(mp3_file.path) do |mp3|
        set_v1_tags(mp3)
        set_v2_tags(mp3)
        add_cover_image(mp3)
      end
      set_comments_tag(mp3_file)
    end

    def set_v1_tags(mp3)
      mp3.tag1.title = @instance.full_title
      mp3.tag1.artist = 'thoughtbot'
      mp3.tag1.album = @instance.show.title
      mp3.tag1.year = @instance.published_on.year if @instance.published_on
    end

    def set_v2_tags(mp3)
      mp3.tag2.TIT2 = @instance.full_title
      set_authorship_tags(mp3)
      mp3.tag2.TALB = @instance.show.title
      mp3.tag2.TCON = 'Podcast'
      mp3.tag2.TYER = @instance.published_on.year
      mp3.tag2.PCST = "\x00\x00\x00\x00"
      mp3.tag2.TGID = show_episode_url(@instance.show, @instance, host: HOST)
      mp3.tag2.WXXX = "\x00\x00\x00#{show_episode_url(@instance.show, @instance, host: HOST)}\00"
      mp3.tag2.WFED = "\x00#{show_episodes_url(@instance.show, format: :xml, host: HOST)}\x00"
      mp3.tag2.TDES = "#{@instance.description}\n\n#{@instance.notes}"
      mp3.tag2.TDRL = @instance.published_on.to_s
    end

    def set_comments_tag(mp3_file)
      Mp3Info.open(mp3_file.path) do |mp3|
        mp3.tag2.COMM = @instance.description
      end
    end

    def set_authorship_tags(mp3)
      %w(TPE1 TOPE TENC TPUB).each do |field|
        mp3.tag2[field] = 'thoughtbot'
      end
      mp3.tag2.TCOP = '2013 thoughtbot, inc.'
    end

    def extract_mp3_info(mp3_file)
      @instance.file_size = mp3_file.size
      Mp3Info.open(mp3_file.path) do |mp3|
        @instance.duration = mp3.length.to_i
      end
    end

    def add_cover_image(mp3)
      mp3.tag2.add_picture(cover_image)
    end

    def cover_image
      File.new(cover_image_path, 'rb').read
    end

    def cover_image_path
      File.join(Rails.root, 'app', 'assets', 'images', 'podcast', "#{@instance.show.slug}-1400.jpg")
    end
  end
end
