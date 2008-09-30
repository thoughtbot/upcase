class HelperTestGenerator < Rails::Generator::NamedBase  

  attr_reader :helper_class_name, :directory_slashes

  def initialize(runtime_args, runtime_options = {})
    @helper_class_name = Inflector.camelize(runtime_args.first)
    super
  end

  def manifest
    record do |m|
      m.template 'helper_testcase.rb', 'test/helper_testcase.rb'
      
      output_path = File.join('test/unit/helpers', "#{@helper_class_name.underscore}_helper_test.rb")
      m.directory File.join(File.dirname(output_path))

      # Make slashes relative to the test/unit/helpers folder
      @directory_slashes = '/..' * (output_path.split('/').length - 3)
      m.template 'helper_test.rb', File.join(output_path)
    end
  end
end
