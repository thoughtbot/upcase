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
    add_to_review_queue

    expect(page).to have_content("Question 2")
    expect(last_question_attempt.confidence).to eq(1)
  end

  scenario "and navigates to the next question directly" do
    quiz = create(:quiz)
    create_list(:question, 2, quiz: quiz)

    navigate_to_quiz(quiz)
    navigate_to_next_flashcard

    expect(page).to have_content("Question 2")
  end

  context "and completes the quiz" do
    scenario "is taken to a quiz results summary page" do
      question = create(:question)

      navigate_to_quiz(question.quiz)
      add_to_review_queue

      expect(current_path).to eq(quiz_results_path(question.quiz))
    end

    scenario "and returns to the expanded question to review it" do
      question = create(:question)

      navigate_to_quiz(question.quiz)
      add_to_review_queue
      review_question(question)

      expect(page).to have_content(question.answer)

      return_to_results

      expect(current_path).to eq(quiz_results_path(question.quiz))
    end

    scenario "and marks a question as needing review" do
      question = create(:question)

      navigate_to_quiz(question.quiz)
      add_to_review_queue
      visit quizzes_path

      within(".kept-flashcards") do
        expect(page).to have_link(question.title)
      end
    end
  end

  def navigate_to_quiz(quiz)
    visit quizzes_path(as: create(:subscriber, :with_quiz_access))
    within quizzes_list do
      click_on quiz.title
    end
  end

  def navigate_to_next_flashcard
    reveal_answer
    click_button I18n.t("questions.hidden_answer.next-flashcard")
  end

  def add_to_review_queue
    click_button I18n.t("questions.hidden_answer.save-for-review")
  end

  def review_question(question)
    click_on question.title
  end

  def return_to_results
    click_on I18n.t("questions.show.return-to-results")
  end

  def question_summary(question)
    find(".to-flashcard[data-question='#{question.id}']")
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
