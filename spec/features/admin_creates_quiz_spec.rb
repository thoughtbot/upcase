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

  scenario "and adds a question" do
    quiz = create(:quiz)
    question = build_stubbed(:question)

    visit admin_quiz_path(quiz, as: create(:admin))
    click_on "Add Question"
    submit_question_form_for question

    expect(current_path).to eq(admin_quiz_path(quiz))
    expect(page).to have_css(".question", text: question.title)
  end

  scenario "and can see a live preview of the question", js: true do
    quiz = create(:quiz)

    visit new_admin_quiz_question_path(quiz, as: create(:admin))
    fill_in "Prompt", with: "Hello **world**"

    expect(question_preview).to have_css("strong", text: "world")
  end

  scenario "and edits a question", js: true do
    edit_question_as_admin

    fill_in "Title", with: "Updated Question Title"
    click_on "Update Question"

    expect(page).to have_css(".question", text: "Updated Question Title")
  end

  def expect_first_listed_question_to_be(question)
    expect(page).
      to have_css(".question:first-child .title", text: question.title)
  end

  def edit_question_position_to_be(question, position)
    edit_question(question)
    fill_in "Position", with: position
    click_on "Update Question"
  end

  def edit_question_as_admin(question = create(:question))
    visit admin_quiz_path(question.quiz, as: create(:admin))
    edit_question(question)
  end

  def edit_question(question)
    within "tr[data-id='#{question.id}']" do
      click_on "Edit"
    end
  end

  def submit_question_form_for(question)
    fill_in "Title", with: question.title
    fill_in "Prompt", with: question.prompt
    fill_in "Answer", with: question.answer
    click_on "Create Question"
  end

  def question_preview
    find(".question-preview")
  end

  def create_quiz_with_title(title)
    click_on "Add Quiz"
    fill_in "Title", with: title
    click_on "Create Quiz"
  end
end
