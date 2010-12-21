= MySQL/Ruby Interface

* http://mysql-win.rubyforge.org
* http://rubyforge.org/projects/mysql-win
* http://github.com/luislaven/mysql-gem

== DESCRIPTION

This is the MySQL API module for Ruby. It provides the same functions for Ruby
programs that the MySQL C API provides for C programs.

This is a conversion of tmtm's original extension into a proper RubyGems.

=== Warning about incompatible MySQL versions

Mixing MySQL versions will generate segmentation faults.

Running the binary version of this gem against a different version of MySQL
shared library <tt>libMySQL.dll</tt> will generate segmentation faults and
terminate your application.

Please use the exact same MAJOR.MINOR version of MySQL, see History.txt for
specific version of MySQL used to build the binaries.
