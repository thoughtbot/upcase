module AbTests
  class LandingHeadlineTest < Base
    def setup
      variation(ab_test(test_name, "orig", "v1"))
    end

    def finish
      finished(test_name)
    end

  private

    def variation(key)
      # The :name value isn't needed in all variations. Passing it when it is 
      # not needed allows for simpler code and will do no harm.
      I18n.t("headlines.landing.#{key}", name: I18n.t('shared.subscription.name'))
    end
  end
end
