class User < ActiveRecord::Base
  include Clearance::User

  attr_accessible :last_name, :password, :email, :first_name

  has_many :purchases

  validates_presence_of :first_name, :last_name

  def name
    [first_name, last_name].join(' ')
  end
end
