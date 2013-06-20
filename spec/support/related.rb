shared_examples 'it has related items' do
  describe '#related' do
    it 'initializes and returns the related object' do
      item = described_class.new
      related = stub
      Related.stubs(new: related)

      item.related

      expect(Related).to have_received(:new).with(item)
    end
  end
end
