shared_examples 'Purchaseable plan' do
  describe '#after_purchase_url' do
    it 'returns the dashboard path' do
      dashboard_path = 'http://example.com/dashboard'
      plan = build_stubbed(factory_name)
      purchase = build_stubbed(:purchase, purchaseable: plan)
      controller = stub('controller')
      controller.stubs(:dashboard_path).returns(dashboard_path)

      after_purchase_url = plan.after_purchase_url(controller, purchase)

      expect(after_purchase_url).to eq(dashboard_path)
    end
  end

  def factory_name
    described_class.name.underscore.to_sym
  end
end
