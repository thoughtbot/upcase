require 'spec_helper'

describe PurchaseableDecorator, '#overlaps_with_other_purchases?' do
  it 'returns false if the passed in purchaseable does not have a set start and end date' do
    user = create(:user)
    book_purchase = create(:book_purchase, user: user)

    book_purchase = PurchaseableDecorator.new(book_purchase)

    expect(book_purchase.overlaps_with_other_purchases?(user)).to be_false
  end

  it 'returns false if trying to register for a workshop with no conflict' do
    user = create(:user)
    workshop = create(:workshop, length_in_days: 20)
    Timecop.travel(26.days.ago) do
      create_subscriber_purchase_from_purchaseable(workshop, user)
    end
    new_workshop = create(:workshop, length_in_days: 20)

    new_workshop = PurchaseableDecorator.new(new_workshop)

    expect(new_workshop.overlaps_with_other_purchases?(user)).to be_false
  end

  it 'returns true if trying to register for a workshop that overlaps with a previous purchase' do
    user = create(:user)
    workshop = create(:workshop, length_in_days: 20)
    Timecop.travel(10.days.ago) do
      create_subscriber_purchase_from_purchaseable(workshop, user)
    end

    new_workshop = create(:workshop, length_in_days: 20)
    new_workshop = PurchaseableDecorator.new(new_workshop)

    expect(new_workshop.overlaps_with_other_purchases?(user)).to be_true
  end
end
