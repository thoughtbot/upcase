# Monkey-patch so that `deny_access` asserts that it redirects to
# `Clearance.configuration.redirect_url`, not the literal string "/"

module Clearance
  module Testing
    module Matchers
      class DenyAccessMatcher
        private

        def denied_access_url
          if @controller.signed_in?
            Clearance.configuration.redirect_url
          else
            @controller.sign_in_url
          end
        end
      end
    end
  end
end
