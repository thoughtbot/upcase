require "rails_helper"

feature "Admin creates a quiz" do
  scenario "is redirected away if not an admin" do
    visit new_admin_quiz_path(as: create(:subscriber))

    expect(current_path).to eq(practice_path)
  end

  scenario "successfully" do
    visit admin_quizzes_path(as: create(:admin))

    create_quiz_with_title("A new quiz")

    visit admin_quizzes_path

    expect(page).to have_css(".quiz", count: 1, text: "A new quiz")
  end

  scenario "and adds a flashcard" do
    quiz = create(:quiz)
    flashcard = build_stubbed(:flashcard)

    visit admin_quiz_path(quiz, as: create(:admin))
    click_on "Add Flashcard"
    submit_flashcard_form_for flashcard

    expect(current_path).to eq(admin_quiz_path(quiz))
    expect(page).to have_css(".flashcard", text: flashcard.title)
  end

  scenario "and can see a live preview of the flashcard", js: true do
    quiz = create(:quiz)

    visit new_admin_quiz_flashcard_path(quiz, as: create(:admin))
    fill_in "Prompt", with: "Hello **world**"

    expect(flashcard_preview).to have_css("strong", text: "world")
  end

  scenario "and edits a flashcard", js: true do
    edit_flashcard_as_admin

    fill_in "Title", with: "Updated Flashcard Title"
    click_on "Update Flashcard"

    expect(page).to have_css(".flashcard", text: "Updated Flashcard Title")
  end

  def expect_first_listed_flashcard_to_be(flashcard)
    expect(page).
      to have_css(".flashcard:first-child .title", text: flashcard.title)
  end

  def edit_flashcard_position_to_be(flashcard, position)
    edit_flashcard(flashcard)
    fill_in "Position", with: position
    click_on "Update Flashcard"
  end

  def edit_flashcard_as_admin(flashcard = create(:flashcard))
    visit admin_quiz_path(flashcard.quiz, as: create(:admin))
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

  def create_quiz_with_title(title)
    click_on "Add Quiz"
    fill_in "Title", with: title
    click_on "Create Quiz"
  end
end
