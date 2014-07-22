require 'spec_helper'

describe LineItem do
  describe '#==' do
    it 'returns true if the other line item has the same stripe line item' do
      stripe_line_item = stub('stripe_line_item')
      line_item_one = LineItem.new(stripe_line_item)
      line_item_two = LineItem.new(stripe_line_item)

      expect(line_item_one).to eq(line_item_two)
    end

    it 'returns false if the other line item has another stripe line item' do
      stripe_line_item_one = stub('stripe_line_item_one')
      stripe_line_item_two = stub('stripe_line_item_two')
      line_item_one = LineItem.new(stripe_line_item_one)
      line_item_two = LineItem.new(stripe_line_item_two)

      expect(line_item_one).not_to eq(line_item_two)
    end

    it 'returns false if the other object is not a line item' do
      line_item = LineItem.new(stub('stripe_line_item'))

      expect(line_item).not_to eq(Object.new)
    end
  end

  describe '#amount' do
    it 'returns the dollar amount of the stripe line item' do
      stripe_line_item = stub('stripe_line_item', amount: 1234)
      line_item = LineItem.new(stripe_line_item)

      expect(line_item.amount).to eq(12.34)
    end
  end

  describe '#description' do
    context 'the stripe line item is a subscription' do
      context 'the subscription is not canceled' do
        it 'returns a description based on the subscription plan' do
          plan = stub('plan', name: 'Plan')
          stripe_line_item = stub(
            'stripe_line_item',
            object: 'line_item',
            type: 'subscription',
            plan: plan
          )
          line_item = LineItem.new(stripe_line_item)

          expect(line_item.description).to eq(
            I18n.t(
              "line_item.plan_description",
              plan_name: stripe_line_item.plan.name
            )
          )
        end
      end

      context 'the subscription is canceled' do
        it 'returns a description based on the subscription plan' do
          stripe_line_item = stub(
            'stripe_line_item',
            object: 'line_item',
            type: 'subscription',
            plan: nil
          )
          line_item = LineItem.new(stripe_line_item)

          expect(line_item.description).to eq(
            I18n.t("line_item.canceled_description")
          )
        end
      end
    end

    context 'the stripe line item is not a subscription' do
      it 'returns the stripe line items description' do
        stripe_line_item = stub(
          'stripe_line_item',
          object: 'invoiceitem',
          description: 'Some line item'
        )
        line_item = LineItem.new(stripe_line_item)

        expect(line_item.description).to eq('Some line item')
      end
    end
  end
end
