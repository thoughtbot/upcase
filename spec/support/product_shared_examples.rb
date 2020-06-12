shared_examples "a class inheriting from Product" do
  it { should have_many(:classifications) }
  it { should have_many(:topics).through(:classifications) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:sku) }
  it { should validate_presence_of(:type) }

  context "title" do
    it "describes the product name and type" do
      product = build_stubbed_product(name: "Juice")

      expect(product.title).to eq "Juice: a #{product.offering_type} by thoughtbot"
    end
  end

  context "offering_type" do
    it "returns the lowercase product type" do
      product = build_stubbed_product

      expect(product.offering_type).to eq described_class.name.downcase
    end
  end

  def factory_name
    described_class.name.underscore.to_sym
  end

  def build_stubbed_product(attributes = {})
    build_stubbed(factory_name, attributes)
  end
end
