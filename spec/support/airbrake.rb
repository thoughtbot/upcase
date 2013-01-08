shared_examples 'a Delayed Job that notifies Airbrake about errors' do
  describe '#error' do
    it 'notifies Airbrake when an error occurs' do
      Airbrake.stubs(:notify)

      described_class.new(3).error(stub, RuntimeError)

      Airbrake.should have_received(:notify).with(RuntimeError)
    end
  end
end
