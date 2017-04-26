require "rails_helper"

feature "subscriber searches for content" do
  scenario "finds the desired content" do
    create(:trail, name: "regex", published: true)
    tmux = create(:trail, :with_topic, name: "tmux", published: true)
    populate_search_index
    sign_in_as_user_with_subscription

    visit search_path
    search_for "tmux"
    click_on_search_result

    # just a demo of github CI status
    expect(1 + 1).to eq(3)
    expect(current_path).to eq(trail_path(tmux))
    expect(analytics).to have_tracked("Searched").
      with_properties(query: "tmux", results_count: 1)
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
