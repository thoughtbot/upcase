# use rake-compiler for building the extension
require 'rake/extensiontask'

MYSQL_VERSION = "5.0.83"
MYSQL_MIRROR  = ENV['MYSQL_MIRROR'] || "http://mysql.localhost.net.ar"

Rake::ExtensionTask.new('mysql_api', HOE.spec) do |ext|
  # reference where the vendored MySQL got extracted
  mysql_lib = File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', "mysql-#{MYSQL_VERSION}-win32"))

  # define target for extension (supporting fat binaries)
  if RUBY_PLATFORM =~ /mingw/ then
    ruby_ver = RUBY_VERSION.match(/(\d+\.\d+)/)[1]
    ext.lib_dir = "lib/#{ruby_ver}"
  end

  # automatically add build options to avoid need of manual input
  if RUBY_PLATFORM =~ /mswin|mingw/ then
    ext.config_options << "--with-mysql-include=#{mysql_lib}/include"
    ext.config_options << "--with-mysql-lib=#{mysql_lib}/lib/opt"
  else
    ext.cross_compile = true
    ext.cross_platform = ['i386-mingw32', 'i386-mswin32']
    ext.cross_config_options << "--with-mysql-include=#{mysql_lib}/include"
    ext.cross_config_options << "--with-mysql-lib=#{mysql_lib}/lib/opt"
  end
end

# ensure things are compiled prior testing
task :test => [:compile]
