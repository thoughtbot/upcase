class Resource < ActiveRecord::Base
  validates_presence_of :name, :url
end
