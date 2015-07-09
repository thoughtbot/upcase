module AnalyticsHelper
  def analytics
    Analytics.backend
  end

  def stub_analytics
    double("Analytics", track: true).tap do |analytics|
      allow(Analytics).to receive(:new).and_return(analytics)
    end
  end
end
