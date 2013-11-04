module PageObjects
  class Workshop
    include Capybara::DSL
    include Workshops::Application.routes.url_helpers

    attr_reader :workshop

    def initialize(workshop)
      @workshop = workshop
    end

    def load
      visit workshop_path(workshop)
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
