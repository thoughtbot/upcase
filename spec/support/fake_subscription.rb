class FakeSubscription < Hash
  def id
    FactoryBot.generate(:uuid)
  end

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
