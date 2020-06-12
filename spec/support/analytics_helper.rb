module AnalyticsHelper
  def analytics
    Analytics.backend
  end

  def stub_analytics_for(user)
    double("Analytics", track_updated: true).tap do |analytics_stub|
      allow(Analytics).to receive(:new).with(user).and_return(analytics_stub)
    end
  end
end
