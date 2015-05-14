require "rails_helper"

feature "Subscriber views quizzes" do
  scenario "and starts a quiz" do
    question = create(:question)

    navigate_to_quiz(question.quiz)

    expect(page).to have_content(question.prompt)
  end

  scenario "and reveals the answer", js: true do
    question = create(:question)

    navigate_to_quiz(question.quiz)

    expect(page).not_to have_content(question.answer)

    click_on reveal_answer

    expect(page).not_to have_link("Reveal Answer")
    expect(page).to have_content(question.answer)
  end

  scenario "and rates their confidence with a question's content" do
    quiz = create(:quiz)
    create_list(:question, 2, quiz: quiz)

    navigate_to_quiz(quiz)
    mark_confidence_as(3)

    expect(page).to have_content("Question 2")
    expect(last_question_attempt.confidence).to eq(3)
  end

  context "and completes the quiz" do
    scenario "is taken to a quiz results summary page" do
      question = create(:question)

      navigate_to_quiz(question.quiz)
      mark_confidence_as(2)

      expect(question_summary(question)).to have_content(question.title)
      expect(question_summary(question)).to have_css(".confidence", text: 2)
    end

    scenario "and returns to the expanded question to review it" do
      question = create(:question)

      navigate_to_quiz(question.quiz)
      mark_confidence_as(2)
      review_question(question)

      expect(page).to have_content(question.answer)

      return_to_results

      expect(current_path).to eq(quiz_results_path(question.quiz))
    end
  end

  def navigate_to_quiz(quiz)
    visit practice_path(as: create(:subscriber, :with_quiz_access))
    within quizzes_list do
      click_on quiz.title
    end
  end

  def mark_confidence_as(level)
    within ".confidence" do
      click_on level
    end
  end

  def review_question(question)
    click_on question.title
  end

  def return_to_results
    click_on I18n.t("questions.show.return-to-results")
  end

  def question_summary(question)
    find(".attempt[data-question='#{question.id}']")
  end

  def last_question_attempt
    Attempt.last
  end

  def results_title_for(quiz)
    I18n.t("results.show.title", title: quiz.title)
  end

  def quizzes_list
    find(".quizzes")
  end

  def reveal_answer
    I18n.t("questions.hidden_answer.reveal-answer")
  end
end
