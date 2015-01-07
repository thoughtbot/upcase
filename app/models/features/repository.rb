module Features
  class Repository
    def initialize(user:)
      @user = user
    end

    def fulfill
    end

    def unfulfill
      ::Repository.find_each do |repository|
        repository.remove_collaborator(@user)
      end
    end
  end
end
