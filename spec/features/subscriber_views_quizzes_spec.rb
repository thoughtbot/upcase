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

  scenario "and navigates to the next question" do
    quiz = create(:quiz)
    create_list(:question, 2, quiz: quiz)

    navigate_to_quiz(quiz)
    click_on next_question

    expect(page).to have_content("Question 2")
  end

  context "and completes the quiz" do
    scenario "is taken back to the practice page with a success message" do
      question = create(:question)

      navigate_to_quiz(question.quiz)

      click_on return_to_dashbaord

      expect(current_path).to eq(practice_path)
    end
  end

  def navigate_to_quiz(quiz)
    visit practice_path(as: create(:subscriber, :with_quiz_access))
    within quizzes_list do
      click_on quiz.title
    end
  end

  def quizzes_list
    find(".quizzes")
  end

  def next_question
    I18n.t("questions.show.next-question")
  end

  def reveal_answer
    I18n.t("questions.show.reveal-answer")
  end

  def return_to_dashbaord
    I18n.t("questions.show.return-to-dashboard")
  end
end
