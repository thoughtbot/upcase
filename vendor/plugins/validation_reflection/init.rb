
require 'boiler_plate/validation_reflection'

ActiveRecord::Base.class_eval do
  include BoilerPlate::ActiveRecordExtensions::ValidationReflection
  BoilerPlate::ActiveRecordExtensions::ValidationReflection.load_config
  BoilerPlate::ActiveRecordExtensions::ValidationReflection.install(self)
end
