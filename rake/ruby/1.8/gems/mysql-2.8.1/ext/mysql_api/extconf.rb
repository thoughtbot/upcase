# Darwin (OSX) special cases for universal binaries
# This is to avoid the lack of UB binaries for MySQL
if RUBY_PLATFORM =~ /darwin/
  ENV["RC_ARCHS"] = `uname -m`.chomp if `uname -sr` =~ /^Darwin/
 
  # On PowerPC the defaults are fine
  ENV["RC_ARCHS"] = '' if `uname -m` =~ /^Power Macintosh/
end

require 'mkmf'

# Improved detection of mysql_config
# Code from DataObjects do_mysql adapter

# All instances of mysql_config on PATH ...
def mysql_config_paths
  ENV['PATH'].split(File::PATH_SEPARATOR).collect do |path|
    [ "#{path}/mysql_config", "#{path}/mysql_config5" ].
      detect { |bin| File.exist?(bin) }
  end
end

# The first mysql_config binary on PATH ...
def default_mysql_config_path
  mysql_config_paths.compact.first
end

# Allow overriding path to mysql_config on command line using:
# ruby extconf.rb --with-mysql-config=/path/to/mysql_config
if RUBY_PLATFORM =~ /mswin|mingw/
  inc, lib = dir_config('mysql')
  exit 1 unless have_library("libmysql")
elsif mc = with_config('mysql-config', default_mysql_config_path) then
  mc = 'mysql_config' if mc == true
  cflags = `#{mc} --cflags`.chomp
  exit 1 if $? != 0
  libs = `#{mc} --libs`.chomp
  exit 1 if $? != 0
  $CPPFLAGS += ' ' + cflags
  $libs = libs + " " + $libs
else
  inc, lib = dir_config('mysql', '/usr/local')
  libs = ['m', 'z', 'socket', 'nsl', 'mygcc']
  while not find_library('mysqlclient', 'mysql_query', lib, "#{lib}/mysql") do
    exit 1 if libs.empty?
    have_library(libs.shift)
  end
end

have_func('mysql_ssl_set')
have_func('rb_str_set_len')
have_func('rb_thread_start_timer')

if have_header('mysql.h') then
  src = "#include <errmsg.h>\n#include <mysqld_error.h>\n"
elsif have_header('mysql/mysql.h') then
  src = "#include <mysql/errmsg.h>\n#include <mysql/mysqld_error.h>\n"
else
  exit 1
end

# make mysql constant
File.open("conftest.c", "w") do |f|
  f.puts src
end
if defined? cpp_command then
  cpp = Config.expand(cpp_command(''))
else
  cpp = Config.expand sprintf(CPP, $CPPFLAGS, $CFLAGS, '')
end
if RUBY_PLATFORM =~ /mswin/ && !/-E/.match(cpp)
  cpp << " -E"
end
unless system "#{cpp} > confout" then
  exit 1
end
File.unlink "conftest.c"

error_syms = []
IO.foreach('confout') do |l|
  next unless l =~ /errmsg\.h|mysqld_error\.h/
  fn = l.split(/\"/)[1]
  IO.foreach(fn) do |m|
    if m =~ /^#define\s+([CE]R_[0-9A-Z_]+)/ then
      error_syms << $1
    end
  end
end
File.unlink 'confout'
error_syms.uniq!

File.open('error_const.h', 'w') do |f|
  error_syms.each do |s|
    f.puts "    rb_define_mysql_const(#{s});"
  end
end

create_makefile("mysql_api")
