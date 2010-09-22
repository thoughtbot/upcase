class User < ActiveRecord::Base
  include Clearance::User

  validates_presence_of :first_name, :last_name

  has_many :registrations
  has_many :sections, :through => :registrations

  after_create :send_set_password_email

  def registered_for?(section)
    sections.include?(section)
  end

  def name
    [first_name, last_name].join(' ')
  end

  private

  def send_set_password_email
    UserMailer.deliver_set_password(self)
  end
end
