class PrimeForTeamsPurchase < Purchase
  def self.default_scope
    where(
      purchaseable_id: Product.find_by_name("Prime for Teams"),
      purchaseable_type: Product
    )
  end
end
