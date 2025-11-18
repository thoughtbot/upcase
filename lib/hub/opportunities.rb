module Hub
  module Opportunities
    # @see https://github.com/thoughtbot/hub/blob/main/doc/api/restful/opportunities.md#create
    # @param attributes [Hash]
    # @return [Hash]
    def self.create(attributes = {})
      Request.new.post("opportunities", opportunity: attributes)
    end
  end
end
