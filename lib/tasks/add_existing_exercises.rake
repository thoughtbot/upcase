namespace :db do
  desc "Add existing exercises from /db/exercises.html"
  task add_existing_exercises: :environment do
    html = File.read('db/exercises.html')
    doc = Nokogiri::HTML(html)
    exercises = doc.css('.exercises figure.product-card')
    fail "Could not find exercises on page" if exercises.empty?
    exercises.each_with_index do |exercise, i|
      add_exercise(exercise, i + 1)
    end
  end

  def add_exercise(exercise, position)
    title = exercise.at('h4').text
    url = exercise.at('a')[:href]
    description = exercise.css('p').last.text
    Exercise.create!(
      title: title,
      url: url,
      description: description,
      position: position
    )
  end

end
