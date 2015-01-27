require "sinatra/base"

class FakeUpcaseExercises < Sinatra::Base
  disable :protection

  get "/exercises/:slug" do |slug|
    exercise = Exercise.find_by!("url LIKE ?", "%/exercises/#{slug}")
    <<-HTML
      Exercise: #{exercise.name}
    HTML
  end

  not_found do
    <<-HTML
      Bad Request: #{env["REQUEST_METHOD"]} #{env["PATH_INFO"]}
      Edit #{__FILE__} to fake out this request
    HTML
  end
end
