require 'fake_freshbooks'

Before do
  FakeFreshbooks.reset!
  ShamRack.mount(FakeFreshbooks.new, FRESHBOOKS_PATH, 443)
end
