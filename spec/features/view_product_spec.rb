require "rails_helper"

feature "Viewing products" do
  scenario "of different types" do
    book = create(
      :book,
      name: "Book",
      short_description: "An awesome book"
    )
    screencast = create(
      :screencast,
      name: "Video",
      short_description: "An awesome video"
    )

    visit book_url(book)

    expect(page).not_to have_content "includes support"
    expect_page_to_have_meta_description(book.short_description)
    expect_page_to_have_title("Book: a book by thoughtbot")

    visit screencast_url(screencast)

    expect(page).not_to have_content "includes support"
    expect_page_to_have_meta_description(screencast.short_description)
    expect_page_to_have_title("Video: a screencast by thoughtbot")
  end

  scenario "that are inactive" do
    product = create(:book, :inactive)

    visit book_url(product)

    expect(page).not_to have_content "Purchase for Yourself"
    expect(page).to have_content(
      "This book is not currently available."
    )
  end

  scenario "a user views a product without a subscription or license" do
    book = create(
      :book,
      name: "Book",
      short_description: "An awesome book"
    )
    user = create(:user)

    visit book_url(book, as: user)

    expect_page_to_have_title("Book: a book by thoughtbot")
    expect(page).to have_content(
      "Subscribe to #{I18n.t("shared.subscription.name")}"
    )
  end

  scenario "a user views a product with a license without a subscription" do
    book = create(:book, name: "Book title")
    user = create(:user)
    create(:license, user: user, licenseable: book)

    visit book_url(book, as: user)

    expect(page).to have_content("Book title")
    expect(page).to_not have_content(
      "Subscribe to #{I18n.t("shared.subscription.name")}"
    )
  end
end
