shared_examples "a Delayed Job that notifies Honeybadger about errors" do
  describe '#error' do
    it "notifies Honeybadger when an error occurs" do
      allow(Honeybadger).to receive(:notify)

      described_class.new(3).error(double, RuntimeError)

      expect(Honeybadger).to have_received(:notify).with(RuntimeError)
    end
  end
end
