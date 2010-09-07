class User < ActiveRecord::Base
  include Clearance::User

  has_many :registrations
  has_many :sections, :through => :registrations

  def registered_for?(section)
    sections.include?(section)
  end
end
