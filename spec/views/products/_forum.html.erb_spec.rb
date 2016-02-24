require "rails_helper"

describe 'products/_forum_link' do
  context 'when the user has a subscription' do
    it 'includes a link to the forum' do
      render partial: 'products/forum_link', locals: { current_user: user_with_subscription }
      expect(rendered).to include('View Forum')
    end
  end

  context 'when the user does not have a subscription' do
    it 'does not include a link to the forum' do
      render partial: 'products/forum_link', locals: { current_user: user_without_subscription }
      expect(rendered).to_not include('View Forum')
    end
  end

  def user_without_subscription
    double("user", subscriber?: false)
  end

  def user_with_subscription
    double("user", subscriber?: true)
  end
end
