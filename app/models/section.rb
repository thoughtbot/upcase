class Section < ActiveRecord::Base
  belongs_to :course

  delegate :name, :description, :to => :course, :prefix => :course
end
