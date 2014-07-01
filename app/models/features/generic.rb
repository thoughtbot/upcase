# Used for features with no custom fulfilling/unfulfilling logic
module Features
  class Generic
    def initialize(*args)
    end

    def fulfill
    end

    def unfulfill
    end
  end
end
