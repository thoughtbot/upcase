module Features
  class Factory
    GENERIC_FEATURES = %w(
      books
      exercises
      forum
      office_hours
      screencasts
      shows
      workshops
    )
    FULFILLABLE_FEATURES = %w(mentor source_code)
    ALL_FEATURES = GENERIC_FEATURES + FULFILLABLE_FEATURES

    def initialize(user:)
      @user = user
    end

    def new(feature_string_or_symbol)
      @feature_string = feature_string_or_symbol.to_s
      feature_class.new(user: @user)
    end

    private

    def feature_class
      if generic_feature?
        Features::Generic
      else
        "Features::#{@feature_string.classify}".constantize
      end
    end

    def generic_feature?
      @feature_string.in? GENERIC_FEATURES
    end
  end
end
