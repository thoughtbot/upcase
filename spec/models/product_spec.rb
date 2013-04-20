require 'spec_helper'

describe Product do
  # Associations
  it { should have_many(:announcements).dependent(:destroy) }
  it { should have_many(:classifications) }
  it { should have_many(:downloads) }
  it { should have_many(:purchases) }
  it { should have_many(:topics).through(:classifications) }
  it { should have_many(:videos) }

  # Validations
  it { should validate_presence_of(:fulfillment_method) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:sku) }
  it { should validate_presence_of(:product_type) }

  describe '#announcement' do
    it 'calls Announcement.current' do
      Announcement.stubs :current
      product = create(:book_product)
      product.announcement
      Announcement.should have_received(:current)
    end
  end

  describe "#meta_keywords" do
    it { should delegate(:meta_keywords).to(:topics) }
  end

  describe '.books' do
    it 'only includes books' do
      book = create(:book_product)
      create :video_product
      Product.books.should == [book]
    end
  end

  describe '.videos' do
    it 'only includes videos' do
      video = create(:video_product)
      create :book_product
      Product.videos.should == [video]
    end
  end

  describe '.workshops' do
    it 'only includes workshops' do
      workshop = create(:workshop_product)
      create :book_product
      Product.workshops.should == [workshop]
    end
  end

  describe '.subscriptions' do
    it 'returns all subscribeable products' do
      workshop_product = create(:workshop_product)
      book_product = create(:book_product)
      subscribeable_product = create(:subscribeable_product)

      expect(Product.subscriptions).to eq [subscribeable_product]
    end
  end

  describe 'with a discount' do
    it 'returns a discounted individual price' do
      product = create(:product, individual_price: 50)
      product.individual_price.should == 50
      product.discount_percentage = 20
      product.individual_price.should == 40
    end

    it 'returns a discounted company price' do
      product = create(:product, company_price: 50)
      product.company_price.should == 50
      product.discount_percentage = 20
      product.company_price.should == 40
    end

    it 'reports that the product is discounted' do
      product = create(:product, discount_percentage: 20)
      product.should be_discounted
    end
  end

  it 'reports that it is not discounted' do
    product = create(:product, discount_percentage: 0)
    product.should_not be_discounted
  end

  describe 'starts_on' do
    it 'returns today' do
      product = create(:product)
      expect(product.starts_on).to eq Date.today
    end
  end

  describe '#subscription?' do
    it 'returns true if the product is a subscription type' do
      product = build_stubbed(:subscribeable_product)
      expect(product).to be_subscription
    end

    it 'returns false if the product is not a subscription type' do
      product = build_stubbed(:book_product)
      expect(product).not_to be_subscription
    end
  end

  context 'purchase_for' do
    it 'returns the purchase when a user has purchased a product' do
      user = create(:user)
      purchase = create(:purchase, user: user)
      product = purchase.purchaseable

      expect(product.purchase_for(user)).to eq purchase
    end

    it 'returns nil when a user has not purchased a product' do
      user = create(:user)
      purchase = create(:purchase)
      product = purchase.purchaseable

      expect(product.purchase_for(user)).to be_nil
    end
  end

  context 'filename' do
    it 'returns the parameterized product name' do
      book = Product.new(name: 'Backbone.js on Rails')
      expect(book.filename).to eq 'backbone-js-on-rails'
    end

    it 'returns the parameterized file name with format if given' do
      book = Product.new(name: 'Backbone.js on Rails')
      expect(book.filename(:pdf)).to eq 'backbone-js-on-rails.pdf'
    end
  end

  context 'file' do
    it 'returns the file contents from github of the given format' do
      client = stub(contents: 'filecontents')
      Octokit::Client.stubs(new: client)
      book = Product.new(name: 'Book Title', github_url: 'github')

      contents = book.file(:pdf)

      expect(contents).to eq 'filecontents'
      expect(client).to have_received(:contents).
        with(
          'thoughtbot/book-title',
          path: 'release/book-title.pdf',
          accept: 'application/vnd.github.raw'
        )
    end

    it 'returns nil for products not hosted on github' do
      product = Product.new(name: 'Name', github_url: nil)

      expect(product.file(:pdf)).not_to be_present
    end
  end

  context 'title' do
    it 'describes the product name and type' do
      product = build_stubbed(:book_product, name: 'Juice')

      result = product.title

      expect(result).to eq 'Juice: a book by thoughtbot'
    end
  end

  context 'offering_type' do
    it 'returns the product type' do
      product = build_stubbed(:subscribeable_product)

      result = product.offering_type

      expect(result).to eq 'subscription'
    end
  end

  context '#alternates' do
    it 'is empty' do
      product = Product.new

      result = product.alternates

      expect(result).to eq []
    end
  end
end
