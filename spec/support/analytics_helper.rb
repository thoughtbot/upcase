module AnalyticsHelper
  def analytics
    Analytics.backend
  end

  def stub_analytics
    double("Analytics", track: true).tap do |analytics|
      allow(Analytics).to receive(:new).and_return(analytics)
    end
  end

  def stub_analytics_for(user)
    double("Analytics", track_updated: true).tap do |analytics_stub|
      allow(Analytics).to receive(:new).with(user).and_return(analytics_stub)
    end
  end
end
