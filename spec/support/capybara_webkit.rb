Capybara::Webkit.configure do |config|
  config.block_unknown_urls

  # Required so that our Wistia-related JS (like wistiaEmbed.play) doesn't crash
  # in tests.
  config.allow_url("fast.wistia.com")

  # This doesn't actually hit Stripe, because we have FakeStripe running. But we
  # need to "allow" it or else it won't get to FakeStripe.
  config.allow_url("stripe.com")
end
