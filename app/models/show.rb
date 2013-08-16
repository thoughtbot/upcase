class Show < ActiveRecord::Base
  has_many :episodes

  validates :credits, presence: true
  validates :description, presence: true
  validates :email, presence: true
  validates :itunes_url, presence: true
  validates :keywords, presence: true
  validates :short_description, presence: true
  validates :slug, presence: true
  validates :title, presence: true

  def to_param
    slug
  end

  def short_title
    title.split.first(2).join(' ')
  end
end
