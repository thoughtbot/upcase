class Teacher < ActiveRecord::Base
  before_save :set_gravatar_hash

  protected

  def set_gravatar_hash
    self.gravatar_hash = Digest::MD5.hexdigest(self.email.strip.downcase)
  end
end
