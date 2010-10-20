#!/usr/local/bin/ruby
# $Id: test.rb 244 2009-02-01 08:43:39Z tommy $

require "test/unit"
require 'ostruct'
require 'mysql'

CONFIG = OpenStruct.new
CONFIG.host = ENV['MYSQL_HOST'] || 'localhost'
CONFIG.port = ENV['MYSQL_PORT'] || '3306'
CONFIG.user = ENV['MYSQL_USER'] || 'root'
CONFIG.pass = ENV['MYSQL_PASS'] || ''
CONFIG.sock = ENV['MYSQL_SOCK']
CONFIG.flag = ENV['MYSQL_FLAG']
CONFIG.database = ENV['MYSQL_DATABASE'] || 'test'

class TC_Mysql < Test::Unit::TestCase
  def setup()
    @host = CONFIG.host
    @user = CONFIG.user
    @pass = CONFIG.pass
    @db   = CONFIG.database

    @port = CONFIG.port.to_i
    @sock = CONFIG.sock
    @flag = CONFIG.flag.to_i
  end

  def teardown()
  end

  def test_version()
    assert_equal(20801, Mysql::VERSION)
  end

  def test_init()
    assert_nothing_raised{@m = Mysql.init}
    assert_nothing_raised{@m.close}
  end

  def test_real_connect()
    assert_nothing_raised{@m = Mysql.real_connect(@host, @user, @pass, @db, @port, @sock, @flag)}
    assert_nothing_raised{@m.close}
  end

  def test_connect()
    assert_nothing_raised{@m = Mysql.connect(@host, @user, @pass, @db, @port, @sock, @flag)}
    assert_nothing_raised{@m.close}
  end

  def test_new()
    assert_nothing_raised{@m = Mysql.new(@host, @user, @pass, @db, @port, @sock, @flag)}
    assert_nothing_raised{@m.close}
  end

  def test_escape_string()
    assert_equal("abc\\'def\\\"ghi\\0jkl%mno", Mysql.escape_string("abc'def\"ghi\0jkl%mno"))
  end

  def test_quote()
    assert_equal("abc\\'def\\\"ghi\\0jkl%mno", Mysql.quote("abc'def\"ghi\0jkl%mno"))
  end

  def test_get_client_info()
    assert_match(/^\d.\d+.\d+[a-z]?(-.*)?$/, Mysql.get_client_info())
  end

  def test_client_info()
    assert_match(/^\d.\d+.\d+[a-z]?(-.*)?$/, Mysql.client_info())
  end

  def test_options()
    @m = Mysql.init
    assert_equal(@m, @m.options(Mysql::INIT_COMMAND, "SET AUTOCOMMIT=0"))
    assert_equal(@m, @m.options(Mysql::OPT_COMPRESS))
    assert_equal(@m, @m.options(Mysql::OPT_CONNECT_TIMEOUT, 10))
    assert_equal(@m, @m.options(Mysql::GUESS_CONNECTION)) if defined? Mysql::GUESS_CONNECTION
    assert_equal(@m, @m.options(Mysql::OPT_LOCAL_INFILE, true))
#   assert_equal(@m, @m.options(Mysql::OPT_NAMED_PIPE))
#   assert_equal(@m, @m.options(Mysql::OPT_PROTOCOL, 1))
    assert_equal(@m, @m.options(Mysql::OPT_READ_TIMEOUT, 10)) if defined? Mysql::OPT_READ_TIMEOUT
    assert_equal(@m, @m.options(Mysql::OPT_USE_EMBEDDED_CONNECTION)) if defined? Mysql::OPT_USE_EMBEDDED_CONNECTION
    assert_equal(@m, @m.options(Mysql::OPT_USE_REMOTE_CONNECTION)) if defined? Mysql::OPT_USE_REMOTE_CONNECTION
    assert_equal(@m, @m.options(Mysql::OPT_WRITE_TIMEOUT, 10)) if defined? Mysql::OPT_WRITE_TIMEOUT
#   assert_equal(@m, @m.options(Mysql::READ_DEFAULT_FILE, "/tmp/hoge"))
    assert_equal(@m, @m.options(Mysql::READ_DEFAULT_GROUP, "test"))
    assert_equal(@m, @m.options(Mysql::SECURE_AUTH, true)) if defined? Mysql::SECURE_AUTH
#   assert_equal(@m, @m.options(Mysql::SET_CHARSET_DIR, "??"))
    assert_equal(@m, @m.options(Mysql::SET_CHARSET_NAME, "latin1"))
    assert_equal(@m, @m.options(Mysql::SET_CLIENT_IP, "127.0.0.1")) if defined? Mysql::SET_CLIENT_IP
#   assert_equal(@m, @m.options(Mysql::SHARED_MEMORY_BASE_NAME, "xxx"))
    assert_equal(@m, @m.connect(@host, @user, @pass, @db, @port, @sock, @flag))
    @m.close
  end

  def test_real_connect2()
    @m = Mysql.init
    assert_equal(@m, @m.real_connect(@host, @user, @pass, @db, @port, @sock, @flag))
    @m.close
  end

  def test_connect2()
    @m = Mysql.init
    assert_equal(@m, @m.connect(@host, @user, @pass, @db, @port, @sock, @flag))
    @m.close
  end

end

class TC_Mysql2 < Test::Unit::TestCase
  def setup()
    @host = CONFIG.host
    @user = CONFIG.user
    @pass = CONFIG.pass
    @db   = CONFIG.database

    @port = CONFIG.port.to_i
    @sock = CONFIG.sock
    @flag = CONFIG.flag.to_i

    @m = Mysql.new(@host, @user, @pass, @db, @port, @sock, @flag)
  end

  def teardown()
    @m.close if @m
  end

  def test_affected_rows()
    @m.query("create temporary table t (id int)")
    @m.query("insert into t values (1)")
    assert_equal(1, @m.affected_rows)
  end

  def test_autocommit()
    if @m.methods.include? "autocommit" then
      assert_equal(@m, @m.autocommit(true))
      assert_equal(@m, @m.autocommit(false))
    end
  end

#  def test_ssl_set()
#  end

  def test_more_results_next_result()
    if @m.server_version >= 40100 then
      @m.query_with_result = false
      @m.set_server_option(Mysql::OPTION_MULTI_STATEMENTS_ON) if defined? Mysql::OPTION_MULTI_STATEMENTS_ON
      @m.query("select 1,2,3; select 4,5,6")
      res = @m.store_result
      assert_equal(["1","2","3"], res.fetch_row)
      assert_equal(nil, res.fetch_row)
      assert_equal(true, @m.more_results)
      assert_equal(true, @m.more_results?)
      assert_equal(true, @m.next_result)
      res = @m.store_result
      assert_equal(["4","5","6"], res.fetch_row)
      assert_equal(nil, res.fetch_row)
      assert_equal(false, @m.more_results)
      assert_equal(false, @m.more_results?)
      assert_equal(false, @m.next_result)
    end
  end if Mysql.client_version >= 40100

  def test_query_with_block()
    if @m.server_version >= 40100 then
      @m.set_server_option(Mysql::OPTION_MULTI_STATEMENTS_ON)
      expect = [["1","2","3"], ["4","5","6"]]
      @m.query("select 1,2,3; select 4,5,6") {|res|
        assert_equal(1, res.num_rows)
        assert_equal(expect.shift, res.fetch_row)
      }
      assert(expect.empty?)
      expect = [["1","2","3"], ["4","5","6"]]
      assert_raises(Mysql::Error) {
        @m.query("select 1,2,3; hoge; select 4,5,6") {|res|
          assert_equal(1, res.num_rows)
          assert_equal(expect.shift, res.fetch_row)
        }
      }
      assert_equal(1, expect.size)
      expect = [["1","2","3"], ["4","5","6"]]
      assert_raises(Mysql::Error) {
        @m.query("select 1,2,3; select 4,5,6; hoge") {|res|
          assert_equal(1, res.num_rows)
          assert_equal(expect.shift, res.fetch_row)
        }
      }
      assert(expect.empty?)
    end
  end

  def test_query_with_block_single()
    @m.query("select 1,2,3") {|res|
      assert_equal(1, res.num_rows)
      assert_equal(["1","2","3"], res.fetch_row)
    }
  end

  def test_set_server_option()
    if @m.server_version >= 40101 then
      assert_equal(@m, @m.set_server_option(Mysql::OPTION_MULTI_STATEMENTS_ON))
      assert_equal(@m, @m.set_server_option(Mysql::OPTION_MULTI_STATEMENTS_OFF))
    end
  end if Mysql.client_version >= 40101

  def test_sqlstate()
    if @m.server_version >= 40100 then
      if RUBY_PLATFORM !~ /mingw|mswin/ then
        assert_equal("00000", @m.sqlstate)
      else
        assert_equal("HY000", @m.sqlstate)
      end
      assert_raises(Mysql::Error){@m.query("hogehoge")}
      assert_equal("42000", @m.sqlstate)
    end
  end

  def test_query_with_result()
    assert_equal(true, @m.query_with_result)
    assert_equal(false, @m.query_with_result = false)
    assert_equal(false, @m.query_with_result)
    assert_equal(true, @m.query_with_result = true)
    assert_equal(true, @m.query_with_result)
  end

  def test_reconnect()
    assert_equal(false, @m.reconnect)
    assert_equal(true, @m.reconnect = true)
    assert_equal(true, @m.reconnect)
    assert_equal(false, @m.reconnect = false)
    assert_equal(false, @m.reconnect)
  end
end

class TC_MysqlRes < Test::Unit::TestCase
  def setup()
    @host = CONFIG.host
    @user = CONFIG.user
    @pass = CONFIG.pass
    @db   = CONFIG.database

    @port = CONFIG.port.to_i
    @sock = CONFIG.sock
    @flag = CONFIG.flag.to_i

    @m = Mysql.new(@host, @user, @pass, @db, @port, @sock, @flag)
    @m.query("create temporary table t (id int, str char(10), primary key (id))")
    @m.query("insert into t values (1, 'abc'), (2, 'defg'), (3, 'hi'), (4, null)")
    @res = @m.query("select * from t")
  end

  def teardown()
    @res.free
    @m.close
  end

  def test_num_fields()
    assert_equal(2, @res.num_fields)
  end

  def test_num_rows()
    assert_equal(4, @res.num_rows)
  end

  def test_fetch_row()
    assert_equal(["1","abc"], @res.fetch_row)
    assert_equal(["2","defg"], @res.fetch_row)
    assert_equal(["3","hi"], @res.fetch_row)
    assert_equal(["4",nil], @res.fetch_row)
    assert_equal(nil, @res.fetch_row)
  end

  def test_fetch_hash()
    assert_equal({"id"=>"1", "str"=>"abc"}, @res.fetch_hash)
    assert_equal({"id"=>"2", "str"=>"defg"}, @res.fetch_hash)
    assert_equal({"id"=>"3", "str"=>"hi"}, @res.fetch_hash)
    assert_equal({"id"=>"4", "str"=>nil}, @res.fetch_hash)
    assert_equal(nil, @res.fetch_hash)
  end

  def test_fetch_hash2()
    assert_equal({"t.id"=>"1", "t.str"=>"abc"}, @res.fetch_hash(true))
    assert_equal({"t.id"=>"2", "t.str"=>"defg"}, @res.fetch_hash(true))
    assert_equal({"t.id"=>"3", "t.str"=>"hi"}, @res.fetch_hash(true))
    assert_equal({"t.id"=>"4", "t.str"=>nil}, @res.fetch_hash(true))
    assert_equal(nil, @res.fetch_hash)
  end

  def test_each()
    ary = [["1","abc"], ["2","defg"], ["3","hi"], ["4",nil]]
    @res.each do |a|
      assert_equal(ary.shift, a)
    end
  end

  def test_each_hash()
    hash = [{"id"=>"1","str"=>"abc"}, {"id"=>"2","str"=>"defg"}, {"id"=>"3","str"=>"hi"}, {"id"=>"4","str"=>nil}]
    @res.each_hash do |h|
      assert_equal(hash.shift, h)
    end
  end

  def test_data_seek()
    assert_equal(["1","abc"], @res.fetch_row)
    assert_equal(["2","defg"], @res.fetch_row)
    assert_equal(["3","hi"], @res.fetch_row)
    @res.data_seek(1)
    assert_equal(["2","defg"], @res.fetch_row)
  end

  def test_row_seek()
    assert_equal(["1","abc"], @res.fetch_row)
    pos = @res.row_tell
    assert_equal(["2","defg"], @res.fetch_row)
    assert_equal(["3","hi"], @res.fetch_row)
    @res.row_seek(pos)
    assert_equal(["2","defg"], @res.fetch_row)
  end

  def test_field_seek()
    assert_equal(0, @res.field_tell)
    @res.fetch_field
    assert_equal(1, @res.field_tell)
    @res.fetch_field
    assert_equal(2, @res.field_tell)
    @res.field_seek(1)
    assert_equal(1, @res.field_tell)
  end

  def test_fetch_field()
    f = @res.fetch_field
    assert_equal("id", f.name)
    assert_equal("t", f.table)
    assert_equal(nil, f.def)
    assert_equal(Mysql::Field::TYPE_LONG, f.type)
    assert_equal(11, f.length)
    assert_equal(1, f.max_length)
    assert_equal(Mysql::Field::NUM_FLAG|Mysql::Field::PRI_KEY_FLAG|Mysql::Field::PART_KEY_FLAG|Mysql::Field::NOT_NULL_FLAG, f.flags)
    assert_equal(0, f.decimals)
    f = @res.fetch_field
    assert_equal("str", f.name)
    assert_equal("t", f.table)
    assert_equal(nil, f.def)
    assert_equal(Mysql::Field::TYPE_STRING, f.type)
    assert_equal(10, f.length)
    assert_equal(4, f.max_length)
    assert_equal(0, f.flags)
    assert_equal(0, f.decimals)
    f = @res.fetch_field
    assert_equal(nil, f)
  end

  def test_fetch_fields()
    a = @res.fetch_fields
    assert_equal(2, a.size)
    assert_equal("id", a[0].name)
    assert_equal("str", a[1].name)
  end

  def test_fetch_field_direct()
    f = @res.fetch_field_direct(0)
    assert_equal("id", f.name)
    f = @res.fetch_field_direct(1)
    assert_equal("str", f.name)
    assert_raises(Mysql::Error){@res.fetch_field_direct(-1)}
    assert_raises(Mysql::Error){@res.fetch_field_direct(2)}
  end

  def test_fetch_lengths()
    assert_equal(nil,  @res.fetch_lengths())
    @res.fetch_row
    assert_equal([1, 3],  @res.fetch_lengths())
    @res.fetch_row
    assert_equal([1, 4],  @res.fetch_lengths())
    @res.fetch_row
    assert_equal([1, 2],  @res.fetch_lengths())
    @res.fetch_row
    assert_equal([1, 0],  @res.fetch_lengths())
    @res.fetch_row
    assert_equal(nil,  @res.fetch_lengths())
  end

  def test_field_hash()
    f = @res.fetch_field
    h = {
      "name" => "id",
      "table" => "t",
      "def" => nil,
      "type" => Mysql::Field::TYPE_LONG,
      "length" => 11,
      "max_length" => 1,
      "flags" => Mysql::Field::NUM_FLAG|Mysql::Field::PRI_KEY_FLAG|Mysql::Field::PART_KEY_FLAG|Mysql::Field::NOT_NULL_FLAG,
      "decimals" => 0,
    }
    assert_equal(h, f.hash)
    f = @res.fetch_field
    h = {
      "name" => "str",
      "table" => "t",
      "def" => nil,
      "type" => Mysql::Field::TYPE_STRING,
      "length" => 10,
      "max_length" => 4,
      "flags" => 0,
      "decimals" => 0,
    }
    assert_equal(h, f.hash)
  end

  def test_field_inspect()
    f = @res.fetch_field
    assert_equal("#<Mysql::Field:id>", f.inspect)
    f = @res.fetch_field
    assert_equal("#<Mysql::Field:str>", f.inspect)
  end

  def test_is_num()
    f = @res.fetch_field
    assert_equal(true, f.is_num?)
    f = @res.fetch_field
    assert_equal(false, f.is_num?)
  end

  def test_is_not_null()
    f = @res.fetch_field
    assert_equal(true, f.is_not_null?)
    f = @res.fetch_field
    assert_equal(false, f.is_not_null?)
  end

  def test_is_pri_key()
    f = @res.fetch_field
    assert_equal(true, f.is_pri_key?)
    f = @res.fetch_field
    assert_equal(false, f.is_pri_key?)
  end

end

class TC_MysqlStmt < Test::Unit::TestCase
  def setup()
    @host = CONFIG.host
    @user = CONFIG.user
    @pass = CONFIG.pass
    @db   = CONFIG.database

    @port = CONFIG.port.to_i
    @sock = CONFIG.sock
    @flag = CONFIG.flag.to_i

    @m = Mysql.new(@host, @user, @pass, @db, @port, @sock, @flag)
  end

  def teardown()
  end

  def test_init()
    if @m.server_version >= 40100 then
      s = @m.stmt_init()
      assert_equal(Mysql::Stmt, s.class)
      s.close
    end
  end

  def test_prepare()
    if @m.server_version >= 40100 then
      s = @m.prepare("select 1")
      assert_equal(Mysql::Stmt, s.class)
      s.close
    end
  end

end if Mysql.client_version >= 40100

class TC_MysqlStmt2 < Test::Unit::TestCase
  def setup()
    @host = CONFIG.host
    @user = CONFIG.user
    @pass = CONFIG.pass
    @db   = CONFIG.database

    @port = CONFIG.port.to_i
    @sock = CONFIG.sock
    @flag = CONFIG.flag.to_i

    @m = Mysql.new(@host, @user, @pass, @db, @port, @sock, @flag)
    @s = @m.stmt_init()
  end

  def teardown()
    @s.close
    @m.close
  end

  def test_affected_rows()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int, c char(10))")
      @s.prepare("insert into t values (?,?)")
      @s.execute(1, "hoge")
      assert_equal(1, @s.affected_rows())
      @s.execute(2, "hoge")
      @s.execute(3, "hoge")
      @s.prepare("update t set c=?")
      @s.execute("fuga")
      assert_equal(3, @s.affected_rows())
    end
  end

=begin
  def test_attr_get()
    assert_equal(false, @s.attr_get(Mysql::Stmt::ATTR_UPDATE_MAX_LENGTH))
    assert_raises(Mysql::Error){@s.attr_get(999)}
  end

  def test_attr_set()
    @s.attr_set(Mysql::Stmt::ATTR_UPDATE_MAX_LENGTH, true)
    assert_equal(true, @s.attr_get(Mysql::Stmt::ATTR_UPDATE_MAX_LENGTH))
    @s.attr_set(Mysql::Stmt::ATTR_UPDATE_MAX_LENGTH, false)
    assert_equal(false, @s.attr_get(Mysql::Stmt::ATTR_UPDATE_MAX_LENGTH))
    assert_raises(Mysql::Error){@s.attr_set(999, true)}
  end

  def test_bind_param()
    @s.prepare("insert into t values (?,?)")
    @s.bind_param(123, "abc")
    @s.bind_param(Time.now, nil)
    assert_raises(Mysql::Error){@s.bind_param(1, 2, 3)}
    b = @s.bind_param(Bind.new(Mysql::TYPE_TINY, 99, false))
    @s.bind_param(98.765, b)
  end
=end

  def test_bind_result_nil()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int, c char(10), d double, t datetime)")
      @m.query("insert into t values (123, '9abcdefg', 1.2345, 20050802235011)")
      @s.prepare("select * from t")
      @s.bind_result(nil,nil,nil,nil)
      @s.execute
      a = @s.fetch
      assert_equal([123, "9abcdefg", 1.2345, Mysql::Time.new(2005,8,2,23,50,11)], a)
    end
  end

  def test_bind_result_numeric()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int, c char(10), d double, t datetime)")
      @m.query("insert into t values (123, '9abcdefg', 1.2345, 20050802235011)")
      @s.prepare("select * from t")
      @s.bind_result(Numeric, Numeric, Numeric, Numeric)
      @s.execute
      a = @s.fetch
      if Mysql.client_version < 50000 then
        assert_equal([123, 9, 1, 2005], a)
      else
        assert_equal([123, 9, 1, 20050802235011], a)
      end
    end
  end

  def test_bind_result_integer()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int, c char(10), d double, t datetime)")
      @m.query("insert into t values (123, '9abcdefg', 1.2345, 20050802235011)")
      @s.prepare("select * from t")
      @s.bind_result(Integer, Integer, Integer, Integer)
      @s.execute
      a = @s.fetch
      if Mysql.client_version < 50000 then
        assert_equal([123, 9, 1, 2005], a)
      else
        assert_equal([123, 9, 1, 20050802235011], a)
      end
    end
  end

  def test_bind_result_fixnum()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int, c char(10), d double, t datetime)")
      @m.query("insert into t values (123, '9abcdefg', 1.2345, 20050802235011)")
      @s.prepare("select * from t")
      @s.bind_result(Fixnum, Fixnum, Fixnum, Fixnum)
      @s.execute
      a = @s.fetch
      if Mysql.client_version < 50000 then
        assert_equal([123, 9, 1, 2005], a)
      else
        assert_equal([123, 9, 1, 20050802235011.0], a)
      end
    end
  end

  def test_bind_result_string()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int, c char(10), d double, t datetime)")
      @m.query("insert into t values (123, '9abcdefg', 1.2345, 20050802235011)")
      @s.prepare("select * from t")
      @s.bind_result(String, String, String, String)
      @s.execute
      a = @s.fetch
      assert_equal(["123", "9abcdefg", "1.2345", "2005-08-02 23:50:11"], a)
    end
  end

  def test_bind_result_float()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int, c char(10), d double, t datetime)")
      @m.query("insert into t values (123, '9abcdefg', 1.2345, 20050802235011)")
      @s.prepare("select * from t")
      @s.bind_result(Float, Float, Float, Float)
      @s.execute
      a = @s.fetch
      if Mysql.client_version < 50000 then
        assert_equal([123.0, 9.0, 1.2345, 2005.0], a)
      else
        assert_equal([123.0, 9.0, 1.2345, 20050802235011.0], a)
      end
    end
  end

  def test_bind_result_mysqltime()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int, c char(10), d double, t datetime)")
      @m.query("insert into t values (123, '9abcdefg', 1.2345, 20050802235011)")
      @s.prepare("select * from t")
      @s.bind_result(Mysql::Time, Mysql::Time, Mysql::Time, Mysql::Time)
      @s.execute
      a = @s.fetch
      if Mysql.client_version < 50000 then
        assert_equal([Mysql::Time.new, Mysql::Time.new, Mysql::Time.new, Mysql::Time.new(2005,8,2,23,50,11)], a)
      else
        assert_equal([Mysql::Time.new(2000,1,23), Mysql::Time.new, Mysql::Time.new, Mysql::Time.new(2005,8,2,23,50,11)], a)
      end
    end
  end

  def test_bind_result_unknown()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int, c char(10), d double, t datetime)")
      @m.query("insert into t values (123, '9abcdefg', 1.2345, 20050802235011)")
      @s.prepare("select * from t")
      assert_raises(TypeError){@s.bind_result(Time, nil, nil, nil)}
    end
  end

  def test_bind_result_unmatch_count()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int, c char(10), d double, t datetime)")
      @m.query("insert into t values (123, '9abcdefg', 1.2345, 20050802235011)")
      @s.prepare("select * from t")
      assert_raises(Mysql::Error){@s.bind_result(nil, nil)}
    end
  end

  def test_data_seek()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int)")
      @m.query("insert into t values (0),(1),(2),(3),(4),(5)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_equal([1], @s.fetch)
      assert_equal([2], @s.fetch)
      @s.data_seek(5)
      assert_equal([5], @s.fetch)
      @s.data_seek(1)
      assert_equal([1], @s.fetch)
    end
  end

=begin
  def test_errno()
    @s.errno()
  end

  def test_error()
    @s.error()
  end
=end

  def test_execute()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int)")
      @s.prepare("insert into t values (123)")
      @s.execute()
      assert_equal(1, @s.affected_rows)
      @s.execute()
      assert_equal(1, @s.affected_rows)
      assert_equal(2, @m.query("select count(*) from t").fetch_row[0].to_i)
    end
  end

  def test_execute2()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int)")
      @s.prepare("insert into t values (?)")
      @s.execute(123)
      @s.execute("456")
      @s.prepare("select * from t")
      @s.execute
      assert_equal([123], @s.fetch)
      assert_equal([456], @s.fetch)
    end
  end

  def test_execute3()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int, c char(255), t timestamp)")
      @s.prepare("insert into t values (?,?,?)")
      @s.execute(123, "hoge", Time.local(2005,7,19,23,53,0));
      assert_raises(Mysql::Error){@s.execute(123, "hoge")}
      assert_raises(Mysql::Error){@s.execute(123, "hoge", 0, "fuga")}
      @s.prepare("select * from t")
      @s.execute
      assert_equal([123, "hoge", Mysql::Time.new(2005,7,19,23,53,0)], @s.fetch)
    end
  end

  def test_execute4()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int, c char(255), t timestamp)")
      @s.prepare("insert into t values (?,?,?)")
      @s.execute(nil, "hoge", Mysql::Time.new(2005,7,19,23,53,0));
      @s.prepare("select * from t")
      @s.execute
      assert_equal([nil, "hoge", Mysql::Time.new(2005,7,19,23,53,0)], @s.fetch)
    end
  end

  def test_execute5()
    if @m.server_version >= 40100 then
      [30, 31, 32, 62, 63].each do |i|
        v, = @m.prepare("select cast(? as signed)").execute(2**i-1).fetch
        assert_equal(2**i-1, v)
        v, = @m.prepare("select cast(? as signed)").execute(-(2**i)).fetch
        assert_equal(-(2**i), v)
      end
    end
  end

  def test_fetch()
    if @m.server_version >= 40100 then
      @s.prepare("select 123, 'abc', null")
      @s.execute()
      assert_equal([123, "abc", nil], @s.fetch())
    end
  end

  def test_fetch_bit()
    if @m.client_version >= 50003 and @m.server_version >= 50003 then
      @m.query("create temporary table t (i bit(8))")
      @m.query("insert into t values (0),(-1),(127),(-128),(255),(-255),(256)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal(["\x00"], @s.fetch)
      assert_equal(["\xff"], @s.fetch)
      assert_equal(["\x7f"], @s.fetch)
      assert_equal(["\xff"], @s.fetch)
      assert_equal(["\xff"], @s.fetch)
      assert_equal(["\xff"], @s.fetch)
      assert_equal(["\xff"], @s.fetch)
      @m.query("create temporary table t2 (i bit(64))")
      @m.query("insert into t2 values (0),(-1),(4294967296),(18446744073709551615),(18446744073709551616)")
      @s.prepare("select i from t2")
      @s.execute
      assert_equal(["\x00\x00\x00\x00\x00\x00\x00\x00"], @s.fetch)
      assert_equal(["\xff\xff\xff\xff\xff\xff\xff\xff"], @s.fetch)
      assert_equal(["\x00\x00\x00\x01\x00\x00\x00\x00"], @s.fetch)
      assert_equal(["\xff\xff\xff\xff\xff\xff\xff\xff"], @s.fetch)
      assert_equal(["\xff\xff\xff\xff\xff\xff\xff\xff"], @s.fetch)
    end
  end

  def test_fetch_tinyint()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i tinyint)")
      @m.query("insert into t values (0),(-1),(127),(-128),(255),(-255)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_equal([-1], @s.fetch)
      assert_equal([127], @s.fetch)
      assert_equal([-128], @s.fetch)
      assert_equal([127], @s.fetch)
      assert_equal([-128], @s.fetch)
    end
  end

  def test_fetch_tinyint_unsigned()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i tinyint unsigned)")
      @m.query("insert into t values (0),(-1),(127),(-128),(255),(-255),(256)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([127], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([255], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([255], @s.fetch)
    end
  end

  def test_fetch_smallint()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i smallint)")
      @m.query("insert into t values (0),(-1),(32767),(-32768),(65535),(-65535),(65536)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_equal([-1], @s.fetch)
      assert_equal([32767], @s.fetch)
      assert_equal([-32768], @s.fetch)
      assert_equal([32767], @s.fetch)
      assert_equal([-32768], @s.fetch)
    end
  end

  def test_fetch_smallint_unsigned()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i smallint unsigned)")
      @m.query("insert into t values (0),(-1),(32767),(-32768),(65535),(-65535),(65536)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([32767], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([65535], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([65535], @s.fetch)
    end
  end

  def test_fetch_mediumint()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i mediumint)")
      @m.query("insert into t values (0),(-1),(8388607),(-8388608),(16777215),(-16777215),(16777216)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_equal([-1], @s.fetch)
      assert_equal([8388607], @s.fetch)
      assert_equal([-8388608], @s.fetch)
      assert_equal([8388607], @s.fetch)
      assert_equal([-8388608], @s.fetch)
    end
  end

  def test_fetch_mediumint_unsigned()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i mediumint unsigned)")
      @m.query("insert into t values (0),(-1),(8388607),(-8388608),(16777215),(-16777215),(16777216)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([8388607], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([16777215], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([16777215], @s.fetch)
    end
  end

  def test_fetch_int()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int)")
      @m.query("insert into t values (0),(-1),(2147483647),(-2147483648),(4294967295),(-4294967295),(4294967296)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_equal([-1], @s.fetch)
      assert_equal([2147483647], @s.fetch)
      assert_equal([-2147483648], @s.fetch)
      assert_equal([2147483647], @s.fetch)
      assert_equal([-2147483648], @s.fetch)
    end
  end

  def test_fetch_int_unsigned()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int unsigned)")
      @m.query("insert into t values (0),(-1),(2147483647),(-2147483648),(4294967295),(-4294967295),(4294967296)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([2147483647], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([4294967295], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([4294967295], @s.fetch)
    end
  end

  def test_fetch_bigint()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i bigint)")
      @m.query("insert into t values (0),(-1),(9223372036854775807),(-9223372036854775808),(18446744073709551615),(-18446744073709551615),(18446744073709551616)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_equal([-1], @s.fetch)
      assert_equal([9223372036854775807], @s.fetch)
      assert_equal([-9223372036854775808], @s.fetch)
      if @m.server_version >= 50000 then
        assert_equal([9223372036854775807], @s.fetch)
      else
        assert_equal([-1], @s.fetch)                       # MySQL problem
      end
      assert_equal([-9223372036854775808], @s.fetch)
      assert_equal([9223372036854775807], @s.fetch)
    end
  end

  def test_fetch_bigint_unsigned()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i bigint unsigned)")
      @m.query("insert into t values (0),(-1),(9223372036854775807),(-9223372036854775808),(18446744073709551615),(-18446744073709551615),(18446744073709551616)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      if @m.server_version >= 50000 then
        assert_equal([0], @s.fetch)
      else
        assert_equal([18446744073709551615], @s.fetch) # MySQL problem
      end
      assert_equal([9223372036854775807], @s.fetch)
      if @m.server_version >= 50000 then
        assert_equal([0], @s.fetch)
      else
        assert_equal([9223372036854775808], @s.fetch) # MySQL problem
      end
      assert_equal([18446744073709551615], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([18446744073709551615], @s.fetch)
    end
  end

  def test_fetch_float()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i float)")
      @m.query("insert into t values (0),(-3.402823466E+38),(-1.175494351E-38),(1.175494351E-38),(3.402823466E+38)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_in_delta(-3.402823466E+38, @s.fetch[0], 0.000000001E+38)
      assert_in_delta(-1.175494351E-38, @s.fetch[0], 0.000000001E-38)
      assert_in_delta(1.175494351E-38, @s.fetch[0], 0.000000001E-38)
      assert_in_delta(3.402823466E+38, @s.fetch[0], 0.000000001E+38)
    end
  end

  def test_fetch_float_unsigned()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i float unsigned)")
      @m.query("insert into t values (0),(-3.402823466E+38),(-1.175494351E-38),(1.175494351E-38),(3.402823466E+38)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_in_delta(1.175494351E-38, @s.fetch[0], 0.000000001E-38)
      assert_in_delta(3.402823466E+38, @s.fetch[0], 0.000000001E+38)
    end
  end

  def test_fetch_double()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i double)")
      @m.query("insert into t values (0),(-1.7976931348623157E+308),(-2.2250738585072014E-308),(2.2250738585072014E-308),(1.7976931348623157E+308)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_in_delta(-Float::MAX, @s.fetch[0], Float::EPSILON)
      assert_in_delta(-Float::MIN, @s.fetch[0], Float::EPSILON)
      assert_in_delta(Float::MIN, @s.fetch[0], Float::EPSILON)
      assert_in_delta(Float::MAX, @s.fetch[0], Float::EPSILON)
    end
  end

  def test_fetch_double_unsigned()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i double unsigned)")
      @m.query("insert into t values (0),(-1.7976931348623157E+308),(-2.2250738585072014E-308),(2.2250738585072014E-308),(1.7976931348623157E+308)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_equal([0], @s.fetch)
      assert_in_delta(Float::MIN, @s.fetch[0], Float::EPSILON)
      assert_in_delta(Float::MAX, @s.fetch[0], Float::EPSILON)
    end
  end

  def test_fetch_decimal()
    if (@m.server_version >= 50000 and Mysql.client_version >= 50000) or (@m.server_version >= 40100 and @m.server_version < 50000) then
      @m.query("create temporary table t (i decimal)")
      @m.query("insert into t values (0),(9999999999),(-9999999999),(10000000000),(-10000000000)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal(["0"], @s.fetch)
      assert_equal(["9999999999"], @s.fetch)
      assert_equal(["-9999999999"], @s.fetch)
      if @m.server_version < 50000 then
        assert_equal(["10000000000"], @s.fetch)    # MySQL problem
      else
        assert_equal(["9999999999"], @s.fetch)
      end
      assert_equal(["-9999999999"], @s.fetch)
    end
  end

  def test_fetch_decimal_unsigned()
    if (@m.server_version >= 50000 and Mysql.client_version >= 50000) or (@m.server_version >= 40100 and @m.server_version < 50000) then
      @m.query("create temporary table t (i decimal unsigned)")
      @m.query("insert into t values (0),(9999999998),(9999999999),(-9999999998),(-9999999999),(10000000000),(-10000000000)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal(["0"], @s.fetch)
      assert_equal(["9999999998"], @s.fetch)
      assert_equal(["9999999999"], @s.fetch)
      assert_equal(["0"], @s.fetch)
      assert_equal(["0"], @s.fetch)
      assert_equal(["9999999999"], @s.fetch)
      assert_equal(["0"], @s.fetch)
    end
  end

  def test_fetch_date()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i date)")
      @m.query("insert into t values ('0000-00-00'),('1000-01-01'),('9999-12-31')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([Mysql::Time.new(0,0,0)], @s.fetch)
      assert_equal([Mysql::Time.new(1000,1,1)], @s.fetch)
      assert_equal([Mysql::Time.new(9999,12,31)], @s.fetch)
    end
  end

  def test_fetch_datetime()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i datetime)")
      @m.query("insert into t values ('0000-00-00 00:00:00'),('1000-01-01 00:00:00'),('9999-12-31 23:59:59')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([Mysql::Time.new(0,0,0,0,0,0)], @s.fetch)
      assert_equal([Mysql::Time.new(1000,1,1,0,0,0)], @s.fetch)
      assert_equal([Mysql::Time.new(9999,12,31,23,59,59)], @s.fetch)
    end
  end

  def test_fetch_timestamp()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i timestamp)")
      @m.query("insert into t values ('1970-01-02 00:00:00'),('2037-12-30 23:59:59')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([Mysql::Time.new(1970,1,2,0,0,0)], @s.fetch)
      assert_equal([Mysql::Time.new(2037,12,30,23,59,59)], @s.fetch)
    end
  end

  def test_fetch_time()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i time)")
      @m.query("insert into t values ('-838:59:59'),(0),('838:59:59')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([Mysql::Time.new(0,0,0,838,59,59,true)], @s.fetch)
      assert_equal([Mysql::Time.new(0,0,0,0,0,0,false)], @s.fetch)
      assert_equal([Mysql::Time.new(0,0,0,838,59,59,false)], @s.fetch)
    end
  end

  def test_fetch_year()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i year)")
      @m.query("insert into t values (0),(70),(69),(1901),(2155)")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([0], @s.fetch)
      assert_equal([1970], @s.fetch)
      assert_equal([2069], @s.fetch)
      assert_equal([1901], @s.fetch)
      assert_equal([2155], @s.fetch)
    end
  end

  def test_fetch_char()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i char(10))")
      @m.query("insert into t values (null),('abc')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      assert_equal(["abc"], @s.fetch)
    end
  end

  def test_fetch_varchar()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i varchar(10))")
      @m.query("insert into t values (null),('abc')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      assert_equal(["abc"], @s.fetch)
    end
  end

  def test_fetch_binary()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i binary(10))")
      @m.query("insert into t values (null),('abc')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      if @m.server_version >= 50000 then
        assert_equal(["abc\0\0\0\0\0\0\0"], @s.fetch)
      else
        assert_equal(["abc"], @s.fetch)
      end
    end
  end

  def test_fetch_varbinary()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i varbinary(10))")
      @m.query("insert into t values (null),('abc')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      assert_equal(["abc"], @s.fetch)
    end
  end

  def test_fetch_tinyblob()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i tinyblob)")
      @m.query("insert into t values (null),('abc')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      assert_equal(["abc"], @s.fetch)
    end
  end

  def test_fetch_tinytext()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i tinytext)")
      @m.query("insert into t values (null),('abc')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      assert_equal(["abc"], @s.fetch)
    end
  end

  def test_fetch_blob()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i blob)")
      @m.query("insert into t values (null),('abc')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      assert_equal(["abc"], @s.fetch)
    end
  end

  def test_fetch_text()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i text)")
      @m.query("insert into t values (null),('abc')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      assert_equal(["abc"], @s.fetch)
    end
  end

  def test_fetch_mediumblob()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i mediumblob)")
      @m.query("insert into t values (null),('abc')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      assert_equal(["abc"], @s.fetch)
    end
  end

  def test_fetch_mediumtext()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i mediumtext)")
      @m.query("insert into t values (null),('abc')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      assert_equal(["abc"], @s.fetch)
    end
  end

  def test_fetch_longblob()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i longblob)")
      @m.query("insert into t values (null),('abc')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      assert_equal(["abc"], @s.fetch)
    end
  end

  def test_fetch_longtext()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i longtext)")
      @m.query("insert into t values (null),('abc')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      assert_equal(["abc"], @s.fetch)
    end
  end

  def test_fetch_enum()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i enum('abc','def'))")
      @m.query("insert into t values (null),(0),(1),(2),('abc'),('def'),('ghi')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      assert_equal([""], @s.fetch)
      assert_equal(["abc"], @s.fetch)
      assert_equal(["def"], @s.fetch)
      assert_equal(["abc"], @s.fetch)
      assert_equal(["def"], @s.fetch)
      assert_equal([""], @s.fetch)
    end
  end

  def test_fetch_set()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i set('abc','def'))")
      @m.query("insert into t values (null),(0),(1),(2),(3),('abc'),('def'),('abc,def'),('ghi')")
      @s.prepare("select i from t")
      @s.execute
      assert_equal([nil], @s.fetch)
      assert_equal([""], @s.fetch)
      assert_equal(["abc"], @s.fetch)
      assert_equal(["def"], @s.fetch)
      assert_equal(["abc,def"], @s.fetch)
      assert_equal(["abc"], @s.fetch)
      assert_equal(["def"], @s.fetch)
      assert_equal(["abc,def"], @s.fetch)
      assert_equal([""], @s.fetch)
    end
  end

  def test_each()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int, c char(255), d datetime)")
      @m.query("insert into t values (1,'abc','19701224235905'),(2,'def','21120903123456'),(3,'123',null)")
      @s.prepare("select * from t")
      @s.execute
      c = 0
      @s.each do |a|
        case c
        when 0
          assert_equal([1,"abc",Mysql::Time.new(1970,12,24,23,59,05)], a)
        when 1
          assert_equal([2,"def",Mysql::Time.new(2112,9,3,12,34,56)], a)
        when 2
          assert_equal([3,"123",nil], a)
        else
          raise
        end
        c += 1
      end
    end
  end

  def test_field_count()
    if @m.server_version >= 40100 then
      @s.prepare("select 1,2,3")
      @s.execute()
      assert_equal(3, @s.field_count())
      @s.prepare("set @a=1")
      @s.execute()
      assert_equal(0, @s.field_count())
    end
  end

  def test_free_result()
    if @m.server_version >= 40100 then
      @s.free_result()
      @s.prepare("select 1,2,3")
      @s.execute()
      @s.free_result()
    end
  end

  def test_insert_id()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int auto_increment, unique(i))")
      @s.prepare("insert into t values (0)")
      @s.execute()
      assert_equal(1, @s.insert_id())
      @s.execute()
      assert_equal(2, @s.insert_id())
    end
  end

  def test_num_rows()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int)")
      @m.query("insert into t values (1),(2),(3),(4)")
      @s.prepare("select * from t")
      @s.execute
      assert_equal(4, @s.num_rows())
    end
  end

  def test_param_count()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (a int, b int, c int)")
      @s.prepare("select * from t")
      assert_equal(0, @s.param_count())
      @s.prepare("insert into t values (?,?,?)")
      assert_equal(3, @s.param_count())
    end
  end

=begin
  def test_param_metadata()
    @s.param_metadata()
  end
=end

  def test_prepare()
    if @m.server_version >= 40100 then
      @s.prepare("select 1")
      assert_raises(Mysql::Error){@s.prepare("invalid syntax")}
    end
  end

=begin
  def test_reset()
    @s.reset()
  end
=end

  def test_result_metadata()
    if @m.server_version >= 40100 then
      @s.prepare("select 1 foo, 2 bar")
      res = @s.result_metadata()
      f = res.fetch_fields
      assert_equal("foo", f[0].name)
      assert_equal("bar", f[1].name)
    end
  end

  def test_result_metadata_nodata()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int)")
      @s.prepare("insert into t values (1)")
      assert_equal(nil, @s.result_metadata())
    end
  end

  def test_row_seek_tell()
    if @m.server_version >= 40100 then
      @m.query("create temporary table t (i int)")
      @m.query("insert into t values (0),(1),(2),(3),(4)")
      @s.prepare("select * from t")
      @s.execute
      row0 = @s.row_tell
      assert_equal([0], @s.fetch)
      assert_equal([1], @s.fetch)
      row2 = @s.row_seek(row0)
      assert_equal([0], @s.fetch)
      @s.row_seek(row2)
      assert_equal([2], @s.fetch)
    end
  end

=begin
  def test_send_long_data()
    @m.query("create temporary table t (i int, t text)")
    @s.prepare("insert into t values (?,?)")
    @s.send_long_data(1, "long long data ")
    @s.send_long_data(1, "long long data2")
    assert_raises(Mysql::Error){@s.send_long_data(9, "invalid param number")}
    @s.execute(99, "hoge")
    assert_equal("long long data long long data2", @m.query("select t from t").fetch_row[0])
  end
=end

  def test_sqlstate()
    if @m.server_version >= 40100 then
      @s.prepare("select 1")
      if @m.client_version >= 50000 then
        assert_equal("00000", @s.sqlstate)
      else
        assert_equal("", @s.sqlstate)
      end
      assert_raises(Mysql::Error){@s.prepare("hogehoge")}
      assert_equal("42000", @s.sqlstate)
    end
  end

=begin
  def test_store_result()
    @s.store_result()
  end
=end

end if Mysql.client_version >= 40100

class TC_MysqlTime < Test::Unit::TestCase
  def setup()
  end
  def teardown()
  end

  def test_init()
    t = Mysql::Time.new
    assert_equal(0, t.year);
    assert_equal(0, t.month);
    assert_equal(0, t.day);
    assert_equal(0, t.hour);
    assert_equal(0, t.minute);
    assert_equal(0, t.second);
    assert_equal(false, t.neg);
    assert_equal(0, t.second_part);
  end

  def test_year()
    t = Mysql::Time.new
    assert_equal(2005, t.year = 2005)
    assert_equal(2005, t.year)
  end

  def test_month()
    t = Mysql::Time.new
    assert_equal(11, t.month = 11)
    assert_equal(11, t.month)
  end

  def test_day()
    t = Mysql::Time.new
    assert_equal(23, t.day = 23)
    assert_equal(23, t.day)
  end

  def test_hour()
    t = Mysql::Time.new
    assert_equal(15, t.hour = 15)
    assert_equal(15, t.hour)
  end

  def test_minute()
    t = Mysql::Time.new
    assert_equal(58, t.month = 58)
    assert_equal(58, t.month)
  end

  def test_second()
    t = Mysql::Time.new
    assert_equal(34, t.second = 34)
    assert_equal(34, t.second)
  end

  def test_tos()
    t = Mysql::Time.new(2005, 7, 19, 10, 15, 49)
    assert_equal("2005-07-19 10:15:49", t.to_s)
  end

  def test_eql()
    t1 = Mysql::Time.new(2005,7,19,23,56,13)
    t2 = Mysql::Time.new(2005,7,19,23,56,13)
    assert_equal(t1, t2)
  end

end if Mysql.client_version >= 40100
