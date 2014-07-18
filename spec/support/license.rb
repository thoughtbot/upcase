def create_license_from_licenseable(licenseable, user = nil)
  user ||= create(:user)
  License.create(licenseable: licenseable, user: user)
end
