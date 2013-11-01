module PlanForPublicListing
  extend ActiveSupport::Concern

  module ClassMethods
    def featured
      where(featured: true)
    end

    def ordered
      order('individual_price desc')
    end
  end

  def to_param
    sku
  end
end
