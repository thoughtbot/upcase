module Features
  class Licenseable
    def initialize(user:, licenseable_type:)
      @user = user
      @licenseable_type = licenseable_type
    end

    def fulfill
    end

    def unfulfill
      delete_licenses
    end

    private

    attr_reader :user

    def delete_licenses
      licenses.map(&:destroy)
    end

    def licenses
      user.licenses.for_type(@licenseable_type)
    end
  end
end
