require "rails_helper"

feature "Pages" do
  ["/upcase/privacy", "/upcase/terms"].each do |page_url|
    scenario "able to visit #{page_url}" do
      visit page_url

      expect(current_path).to eq(page_url)
    end
  end
end
