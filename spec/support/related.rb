shared_examples 'it has related items' do
  describe '#related' do
    it 'initializes and returns the related object' do
      item = described_class.new
      related = double("Related")
      expect(Related).to receive(:new).and_return(related)

      item.related
    end
  end
end
