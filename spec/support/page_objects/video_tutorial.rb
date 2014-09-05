module PageObjects
  class VideoTutorial
    include Capybara::DSL
    include Upcase::Application.routes.url_helpers

    attr_reader :video_tutorial

    def initialize(video_tutorial)
      @video_tutorial = video_tutorial
    end

    def load
      visit video_tutorial_path(video_tutorial)
    end

    def questions
      all('#id dt')
    end

    def answers
      all('#id dd')
    end

    def has_questions?(*questions)
      questions.reduce do |result, question|
        within '#faq' do
          result && has_content?(question)
        end
      end
    end

    def has_no_questions?
      questions.empty?
    end

    def has_no_answers?
      answers.empty?
    end

    def has_answers?(*answers)
      answers.reduce do |result, answer|
        within '#faq' do
          result && has_content?(answer)
        end
      end
    end

    def located_in?(location)
      has_css?('.location-name', text: location)
    end

    def taught_by?(teacher)
      has_css?('.teachers h2', text: teacher)
    end

    def only_taught_by?(teacher)
      has_css?('.teachers h2', text: teacher, count: 1)
    end

    def held_at?(time_period)
      has_content?(time_period)
    end

    def has_dates?(dates)
      has_content?(dates)
    end

    def has_date_range?
      has_selector?('[data-role=date-range]')
    end

    def has_an_avatar_for?(name)
      has_css?("img[alt='#{name}']")
    end
  end
end
