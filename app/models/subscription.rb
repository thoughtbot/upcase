# This class represents a user's subscription to Learn content
class Subscription < ActiveRecord::Base
  belongs_to :user
end
