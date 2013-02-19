# Opinio Configuration

Opinio.setup do |config|

  # Use this to change the class that calls +opinio+ method 
  config.model_name = "Comment"

  # This is the owner class of the comment (opinio model)
  # config.owner_class_name = "User"

  # Change this if you do not want to allow replies on your comments
  # config.accept_replies = true
  
  # Here you can change the method called to check who is the current user
  # config.current_user_method = :current_user

  # Strip html tags on save comment
  config.strip_html_tags_on_save = true

  # Comments sort order by created_at (DESC or ASC)
  # Note: you can override that easily within each opinio subjectum
  config.sort_order = 'DESC'

  # Wether or not the default opinio controller should set the flash
  # when creating/removing comments
  config.set_flash = true

end
