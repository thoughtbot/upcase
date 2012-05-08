require 'fake_freshbooks'

FakeFreshbooks.reset!
ShamRack.mount(FakeFreshbooks.new, FRESHBOOKS_PATH, 443)
