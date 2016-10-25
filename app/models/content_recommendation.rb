class ContentRecommendation < ActiveRecord::Base
  belongs_to :user
  belongs_to :recommendable, polymorphic: true
end
