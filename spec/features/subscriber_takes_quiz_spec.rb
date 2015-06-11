require "rails_helper"

feature "Subscriber views quizzes" do
  scenario "and starts a quiz" do
    flashcard = create(:flashcard)

    navigate_to_quiz(flashcard.quiz)

    expect(page).to have_content(flashcard.prompt)
  end

  scenario "and reveals the answer", js: true do
    flashcard = create(:flashcard)

    navigate_to_quiz(flashcard.quiz)

    expect(page).not_to have_content(flashcard.answer)

    click_on reveal_answer

    expect(page).not_to have_link("Reveal Answer")
    expect(page).to have_content(flashcard.answer)
  end

  scenario "and rates their confidence with a flashcard's content" do
    quiz = create(:quiz)
    create_list(:flashcard, 2, quiz: quiz)

    navigate_to_quiz(quiz)
    add_to_review_queue

    expect(page).to have_content("Flashcard 2")
    expect(last_flashcard_attempt.confidence).to eq(1)
  end

  scenario "and navigates to the next flashcard directly" do
    quiz = create(:quiz)
    create_list(:flashcard, 2, quiz: quiz)

    navigate_to_quiz(quiz)
    navigate_to_next_flashcard

    expect(page).to have_content("Flashcard 2")
  end

  context "and completes the quiz" do
    scenario "is taken to a quiz results summary page" do
      flashcard = create(:flashcard)

      navigate_to_quiz(flashcard.quiz)
      add_to_review_queue

      expect(current_path).to eq(quiz_results_path(flashcard.quiz))
    end

    scenario "and returns to the expanded flashcard to review it" do
      flashcard = create(:flashcard)

      navigate_to_quiz(flashcard.quiz)
      add_to_review_queue
      review_flashcard(flashcard)

      expect(page).to have_content(flashcard.answer)

      return_to_results

      expect(current_path).to eq(quiz_results_path(flashcard.quiz))
    end

    scenario "after marking a flashcard as needing review" do
      flashcard = create(:flashcard)

      navigate_to_quiz(flashcard.quiz)
      add_to_review_queue
      visit quizzes_path

      within(".kept-flashcards") do
        expect(page).to have_link(flashcard.title)
      end
    end
  end

  scenario "and removes a flashcard from the review queue" do
    flashcard = create(:flashcard)
    user = create(:user)
    create(
      :attempt,
      flashcard: flashcard,
      user: user,
      confidence: Attempt::LOW_CONFIDENCE
    )

    visit quizzes_path(as: user)
    remove_flashcard_from_review_queue

    expect_review_queue_to_be_empty
    expect(page).to(
      have_content I18n.t("attempts.flashcard_removed_from_review_queue")
    )
  end

  def navigate_to_quiz(quiz)
    visit quizzes_path(as: create(:subscriber, :with_quiz_access))
    within quizzes_list do
      click_on quiz.title
    end
  end

  def navigate_to_next_flashcard
    reveal_answer
    click_button I18n.t("flashcards.hidden_answer.next-flashcard")
  end

  def add_to_review_queue
    click_button I18n.t("flashcards.hidden_answer.save-for-review")
  end

  def remove_flashcard_from_review_queue
    within(".kept-flashcards") do
      click_button "Remove"
    end
  end

  def expect_review_queue_to_be_empty
    expect(page).to_not have_css(".kept-flashcards")
  end

  def review_flashcard(flashcard)
    click_on flashcard.title
  end

  def return_to_results
    click_on I18n.t("flashcards.show.return-to-results")
  end

  def flashcard_summary(flashcard)
    find(".to-flashcard[data-flashcard='#{flashcard.id}']")
  end

  def last_flashcard_attempt
    Attempt.last
  end

  def results_title_for(quiz)
    I18n.t("results.show.title", title: quiz.title)
  end

  def quizzes_list
    find(".quizzes")
  end

  def reveal_answer
    I18n.t("flashcards.hidden_answer.reveal-answer")
  end
end
