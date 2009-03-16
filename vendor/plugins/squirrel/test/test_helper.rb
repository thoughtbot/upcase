require 'rubygems'
require 'test/unit'
require 'active_record'
require 'active_record/fixtures'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
RAILS_DEFAULT_LOGGER = ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite3'])

load(File.dirname(__FILE__) + "/schema.rb") if File.exist?(File.dirname(__FILE__) + "/schema.rb")

class Test::Unit::TestCase #:nodoc:
  class << self
    # http://www.gamecreatures.com/blog/2007/08/05/rails-unit-test-fixture_path-nameerror/
    def fixture_path
        File.dirname(__FILE__) + '/fixtures/'
    end

    use_transactional_fixtures = true
    use_instantiated_fixtures  = false

    def load_all_fixtures
      all_fixtures = Dir.glob("#{File.dirname(__FILE__)}/fixtures/*.yml").collect do |f|
        puts "Loading fixture '#{f}'"
        File.basename(f).gsub(/\.yml$/, "").to_sym
      end
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, all_fixtures)
    end
  end

  def create_fixtures(*table_names)
    if block_given?
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names) { yield }
    else
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names)
    end
  end
end
