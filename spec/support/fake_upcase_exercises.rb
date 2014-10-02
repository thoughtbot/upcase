require "sinatra/base"

class FakeUpcaseExercises < Sinatra::Base
  disable :protection

  get "/exercises/:uuid" do |uuid|
    exercise = Exercise.find_by!(uuid: uuid)
    <<-HTML
      Exercise: #{exercise.title}
    HTML
  end

  not_found do
    <<-HTML
      Bad Request: #{env["REQUEST_METHOD"]} #{env["PATH_INFO"]}
      Edit #{__FILE__} to fake out this request
    HTML
  end
end
