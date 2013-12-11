require 'spec_helper'

describe ProductLicense do
  describe "#to_param" do
    it 'returns its product_id' do
      license = ProductLicense.new(product_id: 1)

      expect(license.to_param).to eq('1')
    end
  end

  describe '#to_partial_path' do
    it 'returns a valid path' do
      expect(ProductLicense.new({}).to_partial_path).
        to eq('product_licenses/product_license')
    end
  end

  describe "#discounted?" do
    it 'returns the discounted value given when initialized' do
      license = ProductLicense.new(discounted: 'example-value')

      expect(license.discounted?).to eq('example-value')
    end
  end

  %w(offering_type original_price price sku variant).each do |attribute|
    describe "##{attribute}" do
      it 'returns the value given when initialized' do
        license = ProductLicense.new(attribute.to_sym => 'example-value')

        expect(license.send(attribute)).to eq('example-value')
      end
    end
  end
end
