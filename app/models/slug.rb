class Slug < ActiveRecord::Base
  private

  def read_only
    true
  end
end
