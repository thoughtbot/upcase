class LineItem
  def initialize(stripe_line_item)
    @stripe_line_item = stripe_line_item
  end

  def description
    if subscription?
      subscription_description
    else
      stripe_line_item.description
    end
  end

  def amount
    stripe_line_item.amount / 100.0
  end

  def ==(other)
    other.class == self.class && other.stripe_line_item == stripe_line_item
  end

  protected

  attr_reader :stripe_line_item

  private

  def subscription?
    stripe_line_item.object == 'line_item' &&
    stripe_line_item.type == 'subscription'
  end

  def subscription_description
    if canceled?
      I18n.t("line_item.canceled_description")
    else
      I18n.t(
        "line_item.plan_description",
        plan_name: stripe_line_item.plan.name
      )
    end
  end

  def canceled?
    stripe_line_item.plan.blank?
  end
end
