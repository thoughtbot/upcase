require 'spec_helper'

describe Alternate do
  it 'is activemodel compliant' do
    alternate = build(:alternate)

    result = alternate.to_partial_path

    expect(result).to eq('alternates/alternate')
  end

  it 'is equal to an alternate for the same key and offering' do
    alternate = build(:alternate)
    other_alternate =
      build(:alternate, key: alternate.key, offering: alternate.offering)

    expect(alternate).to eq(other_alternate)
  end

  it 'is unequal to an alternate for a different key' do
    alternate = build(:alternate, key: 'one')
    other_alternate =
      build(:alternate, key: 'two', offering: alternate.offering)

    expect(alternate).not_to eq(other_alternate)
  end

  it 'is unequal to an alternate for a different offering' do
    alternate = build(:alternate)
    other_alternate =
      build(:alternate, key: alternate.key, offering: build(:workshop))

    expect(alternate).not_to eq(other_alternate)
  end
end
