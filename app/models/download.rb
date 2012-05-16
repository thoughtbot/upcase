class Download < ActiveRecord::Base
  belongs_to :product

  has_attached_file :download, {}.merge(PAPERCLIP_DOWNLOAD_STORAGE_OPTIONS)
  validates_presence_of :download_file_name

  def display_name
    "#{download_file_name} (#{helpers.number_to_human_size(download_file_size)})"
  end

  def helpers
    ActionController::Base.helpers
  end

end
