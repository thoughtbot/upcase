class User < ActiveRecord::Base
  include Clearance::User

  validates_presence_of :first_name, :last_name

  has_many :registrations
  has_many :sections, :through => :registrations

  def registered_for?(section)
    sections.include?(section)
  end

  def name
    [first_name, last_name].join(' ')
  end
end
