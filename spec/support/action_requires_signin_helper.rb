module ActionRequiresSigninHelper
  def requires_signed_in_user_to(&block)
    block.call

    expect(response).to redirect_to(sign_in_path)
  end
end

RSpec.configure do |config|
  config.include ActionRequiresSigninHelper, type: :controller
end
