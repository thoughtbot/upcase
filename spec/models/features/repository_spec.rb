require "rails_helper"

describe Features::Repository do
  describe "#unfulfill" do
    it "removes that user as a collaborator" do
      user = double("user")
      repository1 = double("repository1", remove_collaborator: nil)
      repository2 = double("repository2", remove_collaborator: nil)
      repositories_feature = Features::Repository.new(user: user)
      allow(Repository).to receive(:find_each).
        and_yield(repository1).
        and_yield(repository2)

      repositories_feature.unfulfill

      expect(repository1).to have_received(:remove_collaborator).with(user)
      expect(repository2).to have_received(:remove_collaborator).with(user)
    end
  end
end
