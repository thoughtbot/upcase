class Teacher < ActiveRecord::Base
  before_save :set_gravatar_hash
  validates_presence_of :name, :email

  protected

  def set_gravatar_hash
    self.gravatar_hash = Digest::MD5.hexdigest(self.email.strip.downcase)
  end
end
