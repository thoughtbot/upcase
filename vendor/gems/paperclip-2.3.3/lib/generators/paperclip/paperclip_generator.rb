require 'rails/generators/active_record'

class PaperclipGenerator < ActiveRecord::Generators::Base
  desc "Create a migration to add paperclip-specific fields to your model."

  argument :attachment_names, :required => true, :type => :array, :desc => "The names of the attachment(s) to add.",
           :banner => "attachment_one attachment_two attachment_three ..."

  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end

  def generate_migration
    migration_template "paperclip_migration.rb.erb", "db/migrate/#{migration_file_name}"
  end

  protected

  def migration_name
    "add_attachment_#{attachment_names.join("_")}_to_#{name.underscore}"
  end

  def migration_file_name
    "#{migration_name}.rb"
  end

  def migration_class_name
    migration_name.camelize
  end

end
