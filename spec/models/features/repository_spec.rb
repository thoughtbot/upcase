require "rails_helper"

describe Features::Repository do
  describe "#unfulfill" do
    it "removes that user as a collaborator" do
      user = stub("user")
      repositories = [stub("repository"), stub("repository")]
      Repository.stubs(:find_each).multiple_yields(*repositories)
      repositories.each { |repository| repository.stubs(:remove_collaborator) }
      repositories_feature = Features::Repository.new(user: user)

      repositories_feature.unfulfill

      repositories.each do |repository|
        expect(repository).to have_received(:remove_collaborator).with(user)
      end
    end
  end
end
