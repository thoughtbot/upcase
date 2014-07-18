def create_license(type, user = nil)
  licenseable = create(type)
  create_license_from_licenseable(licenseable, user)
end

def create_license_from_licenseable(licenseable, user = nil)
  user ||= create(:user)
  License.create(licenseable: licenseable, user: user)
end
