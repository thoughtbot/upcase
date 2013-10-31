require 'spec_helper'

describe PurchaseableDecorator, '#overlaps_with_other_purchases?' do
  it 'returns false if the passed in purchaseable does not have a set start and end date' do
    user = create(:user)
    book_purchase = create(:book_purchase, user: user)

    book_purchase = PurchaseableDecorator.new(book_purchase)

    expect(book_purchase.overlaps_with_other_purchases?(user)).to be_false
  end

  it 'returns false if trying to register for an ongoing section with no conflict' do
    user = create(:user)
    online_section = create(:online_section, starts_on: 30.days.ago, ends_on: 20.days.ago)
    Timecop.travel(26.days.ago) do
      create_subscriber_purchase_from_purchaseable(online_section, user)
    end
    new_online_section = create(:online_section, starts_on: 22.days.ago.to_date, ends_on: nil)

    new_online_section = PurchaseableDecorator.new(new_online_section)

    expect(new_online_section.overlaps_with_other_purchases?(user)).to be_false
  end

  it 'returns true if trying to register for a section that overlaps with a previous purchase' do
    user = create(:user)
    online_section = create(:online_section, starts_on: 15.days.from_now, ends_on: 20.days.from_now)
    Timecop.travel(26.days.ago) do
      create_subscriber_purchase_from_purchaseable(online_section, user)
    end

    new_online_section = create(:section, starts_on: 16.days.from_now.to_date, ends_on: 20.days.from_now)
    new_online_section = PurchaseableDecorator.new(new_online_section)

    expect(new_online_section.overlaps_with_other_purchases?(user)).to be_true
  end
end
