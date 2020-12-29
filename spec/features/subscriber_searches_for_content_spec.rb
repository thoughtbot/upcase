require "rails_helper"

feature "user searches for content" do
  scenario "finds the desired content" do
    create(:trail, name: "regex", published: true)
    tmux = create(:trail, :with_topic, name: "tmux", published: true)
    populate_search_index
    sign_in

    visit search_path
    search_for "tmux"
    click_on_search_result

    expect(current_path).to eq(trail_path(tmux))
  end

  def search_for(query)
    within ".searches-form" do
      fill_in "query", with: query
      click_on "Search"
    end
  end

  def click_on_search_result
    find(".search-result").find(".title a").click
  end
end
