class Show < Product
  has_many :videos, as: :watchable, dependent: :destroy

  private

  def product_licenses
    []
  end
end
