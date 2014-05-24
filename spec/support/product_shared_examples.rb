shared_examples 'a class inheriting from Product' do
  it { should have_many(:announcements).dependent(:destroy) }
  it { should have_many(:classifications) }
  it { should have_many(:downloads) }
  it { should have_many(:purchases) }
  it { should have_many(:topics).through(:classifications) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:sku) }
  it { should validate_presence_of(:type) }

  describe '#announcement' do
    it 'calls Announcement.current' do
      Announcement.stubs :current
      product = create_product
      product.announcement
      expect(Announcement).to have_received(:current)
    end
  end

  describe '#product_type_symbol' do
    it 'returns product_type_symbol' do
      video = create_product

      expect(video.product_type_symbol).
        to eq(described_class.name.underscore.to_sym)
    end
  end

  describe "#meta_keywords" do
    it { should delegate(:meta_keywords).to(:topics) }
  end

  describe '.newest_first' do
    it 'returns products in reverse chronological order' do
      older = create_product(created_at: 1.day.ago)
      newer = create_product(created_at: Time.zone.today)
      expect(described_class.newest_first).to eq [newer, older]
    end
  end

  describe 'starts_on' do
    it 'returns the given date' do
      product = create_product
      expect(product.starts_on(Time.zone.today)).to eq Time.zone.today
    end
  end

  describe 'ends_on' do
    it 'returns the given date' do
      product = create_product
      expect(product.ends_on(Time.zone.today)).to eq Time.zone.today
    end
  end

  describe '#subscription?' do
    it 'returns false' do
      product = build_stubbed_product
      expect(product).not_to be_subscription
    end
  end

  context 'title' do
    it 'describes the product name and type' do
      product = build_stubbed_product(name: 'Juice')

      expect(product.title).to eq "Juice: a #{product.offering_type} by thoughtbot"
    end
  end

  context 'offering_type' do
    it 'returns the lowercase product type' do
      product = build_stubbed_product

      expect(product.offering_type).to eq described_class.name.downcase
    end
  end

  context '#fulfilled_with_github' do
    it 'is true when product has a github team' do
      product = build(factory_name, :github)
      purchase = build(:purchase, purchaseable: product)

      expect(purchase).to be_fulfilled_with_github
    end

    it 'is false when product has no github team' do
      product = build(factory_name, github_team: nil)
      purchase = build(:purchase, purchaseable: product)

      expect(purchase).not_to be_fulfilled_with_github
    end
  end

  context '#to_aside_partial' do
    it 'returns the path to the aside partial' do
      expect(described_class.new.to_aside_partial).
        to eq "#{described_class.name.underscore.pluralize}/aside"
    end
  end

  def factory_name
    described_class.name.underscore.to_sym
  end

  def create_product(attributes = {})
    create(factory_name, attributes)
  end

  def build_stubbed_product(attributes = {})
    build_stubbed(factory_name, attributes)
  end

  def build_product(attributes = {})
    build(factory_name, attributes)
  end
end
