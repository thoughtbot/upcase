require 'spec_helper'

describe 'Purchases' do
  it 'raise not found if no purchase exists' do
    visit purchase_path('robots.txt')
    expect(page.status_code).to eq(404)
  end
end
