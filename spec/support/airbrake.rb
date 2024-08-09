shared_examples "a Delayed Job that notifies Sentry about errors" do
  describe "#error" do
    it "notifies Sentry when an error occurs" do
      allow(Sentry).to receive(:capture_exception)

      described_class.new(3).error(double, RuntimeError)

      expect(Sentry).to have_received(:capture_exception).with(RuntimeError)
    end
  end
end
