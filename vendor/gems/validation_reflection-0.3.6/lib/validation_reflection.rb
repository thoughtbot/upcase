# encoding: utf-8
#--
# Copyright (c) 2006-2008, Michael Schuerig, michael@schuerig.de
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++
require 'active_record/reflection'
require 'ostruct'

# Based on code by Sebastian Kanthak
# See http://dev.rubyonrails.org/ticket/861
#
module ActiveRecordExtensions # :nodoc:
  module ValidationReflection # :nodoc:

    extend self

    # Look for config/initalizer here in:
    CONFIG_PATH = ::Dir.glob((::File.join(RAILS_ROOT, 'config', '**', 'validation_reflection.rb').to_s rescue '')).first || ''
    CORE_VALIDATONS = [
       :validates_acceptance_of,
       :validates_associated,
       :validates_confirmation_of,
       :validates_exclusion_of,
       :validates_format_of,
       :validates_inclusion_of,
       :validates_length_of,
       :validates_numericality_of,
       :validates_presence_of,
       :validates_uniqueness_of,
     ].freeze
     
    @@reflected_validations = CORE_VALIDATONS.dup
    @@in_ignored_subvalidation = false

    mattr_accessor  :reflected_validations,
                    :in_ignored_subvalidation

    def included(base) # :nodoc:
      return if base.kind_of?(::ActiveRecordExtensions::ValidationReflection::ClassMethods)
      base.extend(ClassMethods)
    end

    # Load config/initializer on load, where ValidationReflection defaults
    # (such as which validations to reflect upon) cane be overridden/extended.
    #
    def load_config
      if ::File.file?(CONFIG_PATH)
        config = ::OpenStruct.new
        config.reflected_validations = @@reflected_validations
        silence_warnings do
          eval(::IO.read(CONFIG_PATH), binding, CONFIG_PATH)
        end
      end
    end

    # Iterate through all validations and store/cache the info
    # for later easy access.
    #
    def install(base)
      @@reflected_validations.each do |validation_type|
        next if base.respond_to?(:"#{validation_type}_with_reflection")
        ignore_subvalidations = false
        
        if validation_type.kind_of?(::Hash)
          ignore_subvalidations = validation_type[:ignore_subvalidations]
          validation_type = validation_type[:method]
        end
        
        base.class_eval %{
          class << self
            def #{validation_type}_with_reflection(*attr_names)
              ignoring_subvalidations(#{ignore_subvalidations}) do
                #{validation_type}_without_reflection(*attr_names)
                remember_validation_metadata(:#{validation_type}, *attr_names)
              end
            end
            alias_method_chain :#{validation_type}, :reflection
          end
        }, __FILE__, __LINE__
      end
    end
    alias :reload :install

    module ClassMethods

      include ::ActiveRecordExtensions::ValidationReflection

      # Returns an array of MacroReflection objects for all validations in the class
      def reflect_on_all_validations
        self.read_inheritable_attribute(:validations) || []
      end

      # Returns an array of MacroReflection objects for all validations defined for the field +attr_name+.
      def reflect_on_validations_for(attr_name)
        self.reflect_on_all_validations.select do |reflection|
          reflection.name == attr_name.to_sym
        end
      end

      private

        # Store validation info for easy and fast access.
        #
        def remember_validation_metadata(validation_type, *attr_names)
          configuration = attr_names.last.is_a?(::Hash) ? attr_names.pop : {}
          attr_names.flatten.each do |attr_name|
            self.write_inheritable_array :validations,
              [::ActiveRecord::Reflection::MacroReflection.new(validation_type, attr_name.to_sym, configuration, self)]
          end
        end

        def ignoring_subvalidations(ignore)
          save_ignore = self.in_ignored_subvalidation
          unless self.in_ignored_subvalidation
            self.in_ignored_subvalidation = ignore
            yield
          end
        ensure
          self.in_ignored_subvalidation = save_ignore
        end

    end
  end
end

ActiveRecord::Base.class_eval do
  include ::ActiveRecordExtensions::ValidationReflection
  ::ActiveRecordExtensions::ValidationReflection.load_config
  ::ActiveRecordExtensions::ValidationReflection.install(self)
end
