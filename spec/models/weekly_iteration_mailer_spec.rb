require "rails_helper"

describe WeeklyIterationMailer do
  describe ".run" do
    it "records suggested content for the user" do
      video = create(:video)
      user = create(:user)
      WeeklyIterationMailer.run(users: users)

      suggestions = user.content_suggestions
      expect(suggestions.count).to eq(1)
      expect(suggestions.first.suggestable).to eq(video)
    end
  end
end
