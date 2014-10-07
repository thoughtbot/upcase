class FakeSubscription < Hash
  def save
  end

  def plan=(plan)
    self[:plan] = plan
  end

  def plan
    self[:plan]
  end

  def quantity=(quantity)
    self[:quantity] = quantity
  end

  def quantity
    self[:quantity]
  end
end
