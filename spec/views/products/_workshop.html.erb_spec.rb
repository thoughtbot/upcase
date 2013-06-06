require 'spec_helper'

describe 'products/_workshop.html.erb' do
  describe 'the forum link' do
    context 'when the user has a Prime subscription' do
      it 'includes a link to the forum' do
        render partial: 'products/workshop.html.erb', locals: { workshop: workshop_stub, current_user: user_with_prime }
        expect(rendered).to include('View Forum')
      end
    end

    context 'when the user does not have a Prime subscription' do
      it 'does not include a link to the forum' do
        render partial: 'products/workshop.html.erb', locals: { workshop: workshop_stub, current_user: user_without_prime }
        expect(rendered).to_not include('View Forum')
      end
    end
  end

  def workshop_stub
    build_stubbed(:online_workshop)
  end

  def user_without_prime
    build_stubbed(:user)
  end

  def user_with_prime
    create(:user, :with_subscription)
  end
end
