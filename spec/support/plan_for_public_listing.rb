shared_examples 'a Plan for public listing' do
  describe '.featured' do
    it 'only includes featured plans' do
      featured = create(factory_name, featured: true)
      _not_featured = create(factory_name, featured: false)

      expect(described_class.featured).to eq [featured]
    end
  end

  describe '.ordered' do
    it 'sorts by individual price' do
      second = create(factory_name, price_in_dollars: 29)
      first = create(factory_name, price_in_dollars: 99)

      expect(described_class.ordered).to eq [first, second]
    end
  end

  describe '#to_param' do
    it 'returns the sku' do
      plan = create_plan
      expect(plan.to_param).to eq plan.sku
    end
  end

  def create_plan
    create(factory_name)
  end

  def factory_name
    described_class.name.underscore.to_sym
  end
end
