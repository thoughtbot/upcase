require "rails_helper"

feature "Admin creates a deck" do
  scenario "is 404 if not an admin" do
    expect do
      visit new_admin_deck_path(as: create(:user))
    end.to raise_error(ActionController::RoutingError)
  end

  scenario "is 404 if not a user" do
    expect do
      visit new_admin_deck_path
    end.to raise_error(ActionController::RoutingError)
  end

  scenario "successfully" do
    visit admin_decks_path(as: create(:admin))

    create_deck_with_title("A new deck")

    visit admin_decks_path

    expect(page).to have_css(".deck", count: 1, text: "A new deck")
  end

  scenario "and adds a flashcard" do
    deck = create(:deck)
    flashcard = build_stubbed(:flashcard)

    visit admin_deck_path(deck, as: create(:admin))
    click_on "Add Flashcard"
    submit_flashcard_form_for flashcard

    expect(current_path).to eq(admin_deck_path(deck))
    expect(page).to have_css(".flashcard", text: flashcard.title)
  end

  scenario "and can see a live preview of the flashcard", js: true do
    deck = create(:deck)

    admin = create(:admin)
    visit new_admin_deck_flashcard_path(deck, as: admin)
    fill_in "Prompt", with: "Hello **world**"

    expect(flashcard_preview).to have_css("strong", text: "world")
  end

  scenario "and edits a flashcard", js: true do
    edit_flashcard_as_admin

    fill_in "Title", with: "Updated Flashcard Title"
    click_on "Update Flashcard"

    expect(page).to have_css(".flashcard", text: "Updated Flashcard Title")
  end

  def edit_flashcard_as_admin(flashcard = create(:flashcard))
    visit admin_deck_path(flashcard.deck, as: create(:admin))
    edit_flashcard(flashcard)
  end

  def edit_flashcard(flashcard)
    within "tr[data-id='#{flashcard.id}']" do
      click_on "Edit"
    end
  end

  def submit_flashcard_form_for(flashcard)
    fill_in "Title", with: flashcard.title
    fill_in "Prompt", with: flashcard.prompt
    fill_in "Answer", with: flashcard.answer
    click_on "Create Flashcard"
  end

  def flashcard_preview
    find(".flashcard-preview")
  end

  def create_deck_with_title(title)
    click_on "Add Deck"
    fill_in "Title", with: title
    click_on "Create Deck"
  end
end
