module LandingHelper
  def sales_context?
    @landing_page || signed_out?
  end
end
