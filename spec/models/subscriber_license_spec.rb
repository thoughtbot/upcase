require 'spec_helper'

describe SubscriberLicense do
  describe "#to_param" do
    it 'returns its product_id' do
      license = SubscriberLicense.new(product_id: 1)

      expect(license.to_param).to eq('1')
    end
  end

  describe '#to_partial_path' do
    it 'returns a valid path' do
      expect(SubscriberLicense.new({}).to_partial_path).
        to eq('subscriber_licenses/subscriber_license')
    end
  end

  describe "#collection?" do
    it 'returns the collection value given when initialized' do
      license = SubscriberLicense.new(collection: 'example-value')

      expect(license.collection?).to eq('example-value')
    end
  end

  %w(offering_type sku).each do |attribute|
    describe "##{attribute}" do
      it 'returns the value given when initialized' do
        license = ProductLicense.new(attribute.to_sym => 'example-value')

        expect(license.send(attribute)).to eq('example-value')
      end
    end
  end
end
