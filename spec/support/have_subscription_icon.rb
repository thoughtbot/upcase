RSpec::Matchers.define :have_subscription_icon do
  match do |article|
    expect(page).to have_css("#article_#{article.id}",
      text: I18n.t('shared.subscriptions.icon'))
  end
end
