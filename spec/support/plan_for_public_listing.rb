shared_examples 'a Plan for public listing' do
  describe '.featured' do
    it 'only featured plans' do
      featured = create(factory_name, featured: true)
      notfeatured = create(factory_name, featured: false)

      expect(described_class.featured).to eq [featured]
    end
  end

  describe '.ordered' do
    it 'sorts by individual price' do
      second = create(factory_name, individual_price: 29)
      first = create(factory_name, individual_price: 99)

      expect(described_class.ordered).to eq [first, second]
    end
  end

  describe '#to_param' do
    it 'returns the sku' do
      plan = create_plan
      plan.to_param.should == "#{plan.sku}"
    end
  end

  def create_plan
    create(factory_name)
  end

  def factory_name
    described_class.name.underscore.to_sym
  end
end
