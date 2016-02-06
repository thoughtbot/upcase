module LandingHelper
  def landing?
    @landing_page || signed_out?
  end
end
