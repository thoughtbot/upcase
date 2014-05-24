require 'spec_helper'

describe 'products/_license.html' do
  it 'renders with licenses and a subscription' do
    stub_active_subscription

    render_with_licenses

    expect(rendered).not_to have_buy_individually_text
  end

  it 'renders with licenses and no subscription' do
    stub_inactive_subscription

    render_with_licenses

    expect(rendered).to have_buy_individually_text
  end

  it 'renders with no licenses and no subscription' do
    stub_inactive_subscription

    render_with_no_licenses

    expect(rendered).not_to have_buy_individually_text
  end

  def stub_active_subscription
    view_stubs(:current_user_has_active_subscription?).returns(true)
  end

  def stub_inactive_subscription
    view_stubs(:current_user_has_active_subscription?).returns(false)
  end

  def render_with_licenses
    render_licenses [build(:product_license)]
  end

  def render_with_no_licenses
    render_licenses []
  end

  def render_licenses(licenses)
    product = build_stubbed(:product)
    render 'products/license', product: product, licenses: licenses
  end

  def have_buy_individually_text
    have_content(I18n.t('products.license.or_buy_individually'))
  end
end
