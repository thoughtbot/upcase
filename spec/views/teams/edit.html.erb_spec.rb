require "rails_helper"

describe 'teams/edit' do
  context 'when team has a next payment' do
    before do
      assign_team(next_payment_on: Date.tomorrow)
      render
    end

    it "shows next charge information" do
      expect(rendered).to include('Your next charge will be')
    end
  end

  context 'when team has no next payment' do
    before do
      assign_team(next_payment_on: nil)
      render
    end

    it "does not show next charge information" do
      expect(rendered).not_to include('Your next charge will be')
    end
  end

  def assign_team(next_payment_on:)
    subscription = build(:team_subscription, next_payment_on: next_payment_on)
    assign(:team, build(:team, subscription: subscription))
  end
end
