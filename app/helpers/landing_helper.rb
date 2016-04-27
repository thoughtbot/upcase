module LandingHelper
  def sales_context?
    landing_page? || signed_out?
  end

  def landing_page?
    @landing_page.present?
  end
end
