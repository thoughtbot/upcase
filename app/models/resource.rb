class Resource < ActiveRecord::Base
  validates_presence_of :name, :url
  belongs_to :course
end
