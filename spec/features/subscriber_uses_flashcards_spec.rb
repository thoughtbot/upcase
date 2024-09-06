require "rails_helper"

feature "user views decks" do
  scenario "and starts a deck" do
    flashcard = create(:flashcard)

    navigate_to_deck(flashcard.deck)

    expect(page).to have_content(flashcard.prompt)
  end

  scenario "and reveals the answer", js: true do
    flashcard = create(:flashcard)

    navigate_to_deck(flashcard.deck)

    expect(page).not_to have_content(flashcard.answer)

    click_on reveal_answer

    expect(page).not_to have_link("Reveal Answer")
    expect(page).to have_content(flashcard.answer)
  end

  scenario "and saves it to their review queue" do
    deck = create(:deck)
    create_list(:flashcard, 2, deck: deck)

    navigate_to_deck(deck)
    add_to_review_queue

    expect(page).to have_content("Flashcard 2")
    expect(page).to have_content(I18n.t("attempts.flashcard_saved"))
    expect(last_flashcard_attempt.confidence).to eq(1)
  end

  scenario "and navigates to the next flashcard directly" do
    deck = create(:deck)
    create_list(:flashcard, 2, deck: deck)

    navigate_to_deck(deck)
    navigate_to_next_flashcard

    expect(page).to have_content("Flashcard 2")
  end

  context "and completes the deck" do
    scenario "is taken to a deck results summary page" do
      flashcard = create(:flashcard)

      navigate_to_deck(flashcard.deck)
      add_to_review_queue

      expect(current_path).to eq(deck_results_path(flashcard.deck))
    end

    scenario "and returns to the expanded flashcard to review it" do
      flashcard = create(:flashcard)

      navigate_to_deck(flashcard.deck)
      add_to_review_queue
      review_flashcard(flashcard)

      expect(page).to have_content(flashcard.answer)

      return_to_results

      expect(current_path).to eq(deck_results_path(flashcard.deck))
    end

    scenario "after marking a flashcard as needing review" do
      flashcard = create(:flashcard)

      navigate_to_deck(flashcard.deck)
      add_to_review_queue
      visit decks_path

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

    visit decks_path(as: user)
    remove_flashcard_from_review_queue

    expect_review_queue_to_be_empty
    expect(page).to(
      have_content(I18n.t("attempts.flashcard_removed_from_review_queue"))
    )
  end

  def navigate_to_deck(deck)
    visit decks_path(as: create(:user))
    within decks_list do
      click_on deck.title
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

  def last_flashcard_attempt
    Attempt.last
  end

  def decks_list
    find(".decks")
  end

  def reveal_answer
    I18n.t("flashcards.hidden_answer.reveal-answer")
  end
end
