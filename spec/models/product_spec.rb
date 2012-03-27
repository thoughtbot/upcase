require 'spec_helper'

describe Product do
  it { should validate_presence_of :name }
  it { should validate_presence_of :sku }
  it { should validate_presence_of :individual_price }
  it { should validate_presence_of :company_price }
  it { should validate_presence_of :fulfillment_method }
end
