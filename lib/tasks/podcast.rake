namespace :podcast do
  namespace :mp3 do
    desc 'Fetch, prep, and upload podcast mp3 files'
    task :process do
      dir = ENV['DIR']
      raw_bucket = 'gr-podcast-raw'
      final_bucket = 'gr-podcast'
      file = ENV['FILE']
      file =~ /-(\d+)\.mp3/
      number = $1.to_i
      title = ENV['TITLE']
      date = ENV['DATE']

      system("s3cmd get s3://#{raw_bucket}/#{file} #{dir}/#{file}")
      system("id3edcmd -ti \"Episode #{number}: #{title}\" -yr #{Date.today.year} -al \"Giant Robots Smashing into other Giant Robots\" -gn Podcast -oa thoughtbot -ar thoughtbot -en thoughtbot -pb thoughtbot -rl #{date} -cp \"#{Date.today.year} thoughtbot, inc.\" -ur \"http://learn.thoughtbot.com/podcast/#{number}\" -pcon -pcid \"http://learn.thoughtbot.com/podcast/#{number}\" -pcfd \"http://learn.thoughtbot.com/podcast.xml\" \"#{dir}/#{file}\"")
      system("\"/Applications/ID3 Editor.app/Contents/MacOS/ID3 Editor\" \"#{dir}/#{file}\"")
      system("s3cmd put #{dir}/#{file} s3://#{final_bucket}/#{file}")
    end
  end
end
