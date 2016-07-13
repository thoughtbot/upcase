#!./bin/rails runner

# This script is designed to be run on Heroku, to set the notes and create
# Markers for the Video with a given slug.
#
# It assumes that it's receiving a Markdown document on STDIN with the marker
# times in the headers, like:
#
#    ## Creating a database view 324
#
# Run it like this:
#
#   cat ../upcase-content/weekly-iteration-notes/scenic.md | staging run ./bin/create-notes-and-markers.rb cool-scenic-slug
#
# The slug is the `video.slug` in the database.

UNDERLINE_HEADER = /^([^\n]+) \d+(\n[-=]+)/m
ATX_HEADER = /^(#+.+) \d+$/

renderer = Redcarpet::Markdown.new(
  Redcarpet::Render::HTML.new(with_toc_data: true),
  autolink: true,
  tables: true,
  fenced_code_blocks: true,
  no_intra_emphasis: true,
)

video_slug = ARGV.first
raw_notes = STDIN.read

# When we run `STDIN.read`, Heroku prints out everything it just read. In order
# to separate that from error messages or output we actually care about, we
# print blank lines.
puts "\n" * 10

doc = Nokogiri::HTML(renderer.render(raw_notes))

# Remove the timestamps from the end of the headers
notes = raw_notes.gsub(UNDERLINE_HEADER, '\1\2').gsub(ATX_HEADER, '\1')

video = Video.find_by!(slug: video_slug)

Video.transaction do
  video.update!(notes: notes)

  video.markers.delete_all
  doc.css("h1, h2, h3, h4, h5, h6").each do |header|
    header[:id].scan(/^(.+)-(\d+)$/).each do |anchor, time|
      video.markers.find_or_create_by!(anchor: anchor, time: time.to_i)
    end
  end
end

puts "\n==================================================\n"
puts "!!! Don't forget to set a summary: https://thoughtbot.com/upcase/admin/video/#{video.id}/edit"
