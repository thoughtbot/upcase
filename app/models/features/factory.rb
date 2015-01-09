module Features
  class Factory
    GENERIC_FEATURES = %w(
      exercises
      forum
      shows
    )
    LICENSEABLE_FEATURES = %w(video_tutorials)
    FULFILLABLE_FEATURES = %w(mentor repositories)
    ALL_FEATURES = GENERIC_FEATURES + LICENSEABLE_FEATURES +
      FULFILLABLE_FEATURES

    def initialize(user:)
      @user = user
    end

    def new(feature_string_or_symbol)
      @feature_string = feature_string_or_symbol.to_s
      feature_class.new(initializer_arguments)
    end

    private

    def feature_class
      if generic_feature?
        Features::Generic
      elsif licenseable_feature?
        Features::Licenseable
      else
        "Features::#{@feature_string.classify}".constantize
      end
    end

    def initializer_arguments
      args = { user: @user }
      if licenseable_feature?
        args.merge(licenseable_type: @feature_string)
      else
        args
      end
    end

    def generic_feature?
      @feature_string.in? GENERIC_FEATURES
    end

    def licenseable_feature?
      @feature_string.in? LICENSEABLE_FEATURES
    end
  end
end
