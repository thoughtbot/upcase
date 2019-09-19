module FlashesHelper
  def user_facing_flashes
    flash.to_hash.slice("alert", "notice", "error")
  end
end
