require 'abstract_unit'
require 'action_controller/integration'

class RequestTest < Test::Unit::TestCase
  def setup
    ActionController::Base.relative_url_root = nil
    @request = ActionController::TestRequest.new
  end

  def teardown
    ActionController::Base.relative_url_root = nil
  end

  def test_remote_ip
    assert_equal '0.0.0.0', @request.remote_ip

    @request.remote_addr = '1.2.3.4'
    assert_equal '1.2.3.4', @request.remote_ip(true)

    @request.remote_addr = '1.2.3.4,3.4.5.6'
    assert_equal '1.2.3.4', @request.remote_ip(true)

    @request.env['HTTP_CLIENT_IP'] = '2.3.4.5'
    assert_equal '1.2.3.4', @request.remote_ip(true)

    @request.remote_addr = '192.168.0.1'
    assert_equal '2.3.4.5', @request.remote_ip(true)
    @request.env.delete 'HTTP_CLIENT_IP'

    @request.remote_addr = '1.2.3.4'
    @request.env['HTTP_X_FORWARDED_FOR'] = '3.4.5.6'
    assert_equal '1.2.3.4', @request.remote_ip(true)

    @request.remote_addr = '127.0.0.1'
    @request.env['HTTP_X_FORWARDED_FOR'] = '3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = 'unknown,3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = '172.16.0.1,3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = '192.168.0.1,3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = '10.0.0.1,3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = '10.0.0.1, 10.0.0.1, 3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = '127.0.0.1,3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = 'unknown,192.168.0.1'
    assert_equal 'unknown', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = '9.9.9.9, 3.4.5.6, 10.0.0.1, 172.31.4.4'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_CLIENT_IP'] = '8.8.8.8'
    e = assert_raises(ActionController::ActionControllerError) {
      @request.remote_ip(true)
    }
    assert_match /IP spoofing attack/, e.message
    assert_match /HTTP_X_FORWARDED_FOR="9.9.9.9, 3.4.5.6, 10.0.0.1, 172.31.4.4"/, e.message
    assert_match /HTTP_CLIENT_IP="8.8.8.8"/, e.message

    @request.env['HTTP_X_FORWARDED_FOR'] = '8.8.8.8, 9.9.9.9'
    assert_equal '8.8.8.8', @request.remote_ip(true)

    @request.env.delete 'HTTP_CLIENT_IP'
    @request.env.delete 'HTTP_X_FORWARDED_FOR'
  end

  def test_domains
    @request.host = "www.rubyonrails.org"
    assert_equal "rubyonrails.org", @request.domain

    @request.host = "www.rubyonrails.co.uk"
    assert_equal "rubyonrails.co.uk", @request.domain(2)

    @request.host = "192.168.1.200"
    assert_nil @request.domain

    @request.host = "foo.192.168.1.200"
    assert_nil @request.domain

    @request.host = "192.168.1.200.com"
    assert_equal "200.com", @request.domain

    @request.host = nil
    assert_nil @request.domain
  end

  def test_subdomains
    @request.host = "www.rubyonrails.org"
    assert_equal %w( www ), @request.subdomains

    @request.host = "www.rubyonrails.co.uk"
    assert_equal %w( www ), @request.subdomains(2)

    @request.host = "dev.www.rubyonrails.co.uk"
    assert_equal %w( dev www ), @request.subdomains(2)

    @request.host = "foobar.foobar.com"
    assert_equal %w( foobar ), @request.subdomains

    @request.host = "192.168.1.200"
    assert_equal [], @request.subdomains

    @request.host = "foo.192.168.1.200"
    assert_equal [], @request.subdomains

    @request.host = "192.168.1.200.com"
    assert_equal %w( 192 168 1 ), @request.subdomains

    @request.host = nil
    assert_equal [], @request.subdomains
  end

  def test_port_string
    @request.port = 80
    assert_equal "", @request.port_string

    @request.port = 8080
    assert_equal ":8080", @request.port_string
  end

  def test_request_uri
    @request.env['SERVER_SOFTWARE'] = 'Apache 42.342.3432'

    @request.set_REQUEST_URI "http://www.rubyonrails.org/path/of/some/uri?mapped=1"
    assert_equal "/path/of/some/uri?mapped=1", @request.request_uri
    assert_equal "/path/of/some/uri", @request.path

    @request.set_REQUEST_URI "http://www.rubyonrails.org/path/of/some/uri"
    assert_equal "/path/of/some/uri", @request.request_uri
    assert_equal "/path/of/some/uri", @request.path

    @request.set_REQUEST_URI "/path/of/some/uri"
    assert_equal "/path/of/some/uri", @request.request_uri
    assert_equal "/path/of/some/uri", @request.path

    @request.set_REQUEST_URI "/"
    assert_equal "/", @request.request_uri
    assert_equal "/", @request.path

    @request.set_REQUEST_URI "/?m=b"
    assert_equal "/?m=b", @request.request_uri
    assert_equal "/", @request.path

    @request.set_REQUEST_URI "/"
    @request.env['SCRIPT_NAME'] = "/dispatch.cgi"
    assert_equal "/", @request.request_uri
    assert_equal "/", @request.path

    ActionController::Base.relative_url_root = "/hieraki"
    @request.set_REQUEST_URI "/hieraki/"
    @request.env['SCRIPT_NAME'] = "/hieraki/dispatch.cgi"
    assert_equal "/hieraki/", @request.request_uri
    assert_equal "/", @request.path
    ActionController::Base.relative_url_root = nil

    ActionController::Base.relative_url_root = "/collaboration/hieraki"
    @request.set_REQUEST_URI "/collaboration/hieraki/books/edit/2"
    @request.env['SCRIPT_NAME'] = "/collaboration/hieraki/dispatch.cgi"
    assert_equal "/collaboration/hieraki/books/edit/2", @request.request_uri
    assert_equal "/books/edit/2", @request.path
    ActionController::Base.relative_url_root = nil

    # The following tests are for when REQUEST_URI is not supplied (as in IIS)
    @request.env['PATH_INFO'] = "/path/of/some/uri?mapped=1"
    @request.env['SCRIPT_NAME'] = nil #"/path/dispatch.rb"
    @request.set_REQUEST_URI nil
    assert_equal "/path/of/some/uri?mapped=1", @request.request_uri
    assert_equal "/path/of/some/uri", @request.path

    ActionController::Base.relative_url_root = '/path'
    @request.env['PATH_INFO'] = "/path/of/some/uri?mapped=1"
    @request.env['SCRIPT_NAME'] = "/path/dispatch.rb"
    @request.set_REQUEST_URI nil
    assert_equal "/path/of/some/uri?mapped=1", @request.request_uri(true)
    assert_equal "/of/some/uri", @request.path(true)
    ActionController::Base.relative_url_root = nil

    @request.env['PATH_INFO'] = "/path/of/some/uri"
    @request.env['SCRIPT_NAME'] = nil
    @request.set_REQUEST_URI nil
    assert_equal "/path/of/some/uri", @request.request_uri
    assert_equal "/path/of/some/uri", @request.path

    @request.env['PATH_INFO'] = "/"
    @request.set_REQUEST_URI nil
    assert_equal "/", @request.request_uri
    assert_equal "/", @request.path

    @request.env['PATH_INFO'] = "/?m=b"
    @request.set_REQUEST_URI nil
    assert_equal "/?m=b", @request.request_uri
    assert_equal "/", @request.path

    @request.env['PATH_INFO'] = "/"
    @request.env['SCRIPT_NAME'] = "/dispatch.cgi"
    @request.set_REQUEST_URI nil
    assert_equal "/", @request.request_uri
    assert_equal "/", @request.path

    ActionController::Base.relative_url_root = '/hieraki'
    @request.env['PATH_INFO'] = "/hieraki/"
    @request.env['SCRIPT_NAME'] = "/hieraki/dispatch.cgi"
    @request.set_REQUEST_URI nil
    assert_equal "/hieraki/", @request.request_uri
    assert_equal "/", @request.path
    ActionController::Base.relative_url_root = nil

    @request.set_REQUEST_URI '/hieraki/dispatch.cgi'
    ActionController::Base.relative_url_root = '/hieraki'
    assert_equal "/dispatch.cgi", @request.path(true)
    ActionController::Base.relative_url_root = nil

    @request.set_REQUEST_URI '/hieraki/dispatch.cgi'
    ActionController::Base.relative_url_root = '/foo'
    assert_equal "/hieraki/dispatch.cgi", @request.path(true)
    ActionController::Base.relative_url_root = nil

    # This test ensures that Rails uses REQUEST_URI over PATH_INFO
    ActionController::Base.relative_url_root = nil
    @request.env['REQUEST_URI'] = "/some/path"
    @request.env['PATH_INFO'] = "/another/path"
    @request.env['SCRIPT_NAME'] = "/dispatch.cgi"
    assert_equal "/some/path", @request.request_uri(true)
    assert_equal "/some/path", @request.path(true)
  end

  def test_host_with_default_port
    @request.host = "rubyonrails.org"
    @request.port = 80
    assert_equal "rubyonrails.org", @request.host_with_port
  end

  def test_host_with_non_default_port
    @request.host = "rubyonrails.org"
    @request.port = 81
    assert_equal "rubyonrails.org:81", @request.host_with_port
  end

  def test_server_software
    assert_equal nil, @request.server_software(true)

    @request.env['SERVER_SOFTWARE'] = 'Apache3.422'
    assert_equal 'apache', @request.server_software(true)

    @request.env['SERVER_SOFTWARE'] = 'lighttpd(1.1.4)'
    assert_equal 'lighttpd', @request.server_software(true)
  end

  def test_xml_http_request
    assert !@request.xml_http_request?
    assert !@request.xhr?

    @request.env['HTTP_X_REQUESTED_WITH'] = "DefinitelyNotAjax1.0"
    assert !@request.xml_http_request?
    assert !@request.xhr?

    @request.env['HTTP_X_REQUESTED_WITH'] = "XMLHttpRequest"
    assert @request.xml_http_request?
    assert @request.xhr?
  end

  def test_reports_ssl
    assert !@request.ssl?
    @request.env['HTTPS'] = 'on'
    assert @request.ssl?
  end

  def test_reports_ssl_when_proxied_via_lighttpd
    assert !@request.ssl?
    @request.env['HTTP_X_FORWARDED_PROTO'] = 'https'
    assert @request.ssl?
  end

  def test_symbolized_request_methods
    [:get, :post, :put, :delete].each do |method|
      self.request_method = method
      assert_equal method, @request.method
    end
  end

  def test_invalid_http_method_raises_exception
    assert_raises(ActionController::UnknownHttpMethod) do
      self.request_method = :random_method
    end
  end

  def test_allow_method_hacking_on_post
    self.request_method = :post
    [:get, :head, :options, :put, :post, :delete].each do |method|
      @request.instance_eval { @parameters = { :_method => method.to_s } ; @request_method = nil }
      @request.request_method(true)
      assert_equal(method == :head ? :get : method, @request.method)
    end
  end

  def test_invalid_method_hacking_on_post_raises_exception
    self.request_method = :post
    @request.instance_eval { @parameters = { :_method => :random_method } ; @request_method = nil }
    assert_raises(ActionController::UnknownHttpMethod) do
      @request.request_method(true)
    end
  end

  def test_restrict_method_hacking
    @request.instance_eval { @parameters = { :_method => 'put' } }
    [:get, :put, :delete].each do |method|
      self.request_method = method
      assert_equal method, @request.method
    end
  end

  def test_head_masquerading_as_get
    self.request_method = :head
    assert_equal :get, @request.method
    assert @request.get?
    assert @request.head?
  end

  def test_xml_format
    @request.instance_eval { @parameters = { :format => 'xml' } }
    assert_equal Mime::XML, @request.format
  end

  def test_xhtml_format
    @request.instance_eval { @parameters = { :format => 'xhtml' } }
    assert_equal Mime::HTML, @request.format
  end

  def test_txt_format
    @request.instance_eval { @parameters = { :format => 'txt' } }
    assert_equal Mime::TEXT, @request.format
  end

  def test_nil_format
    ActionController::Base.use_accept_header, old =
      false, ActionController::Base.use_accept_header

    @request.instance_eval { @parameters = {} }
    @request.env["HTTP_X_REQUESTED_WITH"] = "XMLHttpRequest"
    assert @request.xhr?
    assert_equal Mime::JS, @request.format

  ensure
    ActionController::Base.use_accept_header = old
  end

  def test_content_type
    @request.env["CONTENT_TYPE"] = "text/html"
    assert_equal Mime::HTML, @request.content_type
  end

  def test_format_assignment_should_set_format
    @request.instance_eval { self.format = :txt }
    assert !@request.format.xml?
    @request.instance_eval { self.format = :xml }
    assert @request.format.xml?
  end

  def test_content_no_type
    assert_equal nil, @request.content_type
  end

  def test_content_type_xml
    @request.env["CONTENT_TYPE"] = "application/xml"
    assert_equal Mime::XML, @request.content_type
  end

  def test_content_type_with_charset
    @request.env["CONTENT_TYPE"] = "application/xml; charset=UTF-8"
    assert_equal Mime::XML, @request.content_type
  end

  def test_user_agent
    assert_not_nil @request.user_agent
  end

  def test_parameters
    @request.instance_eval { @request_parameters = { "foo" => 1 } }
    @request.instance_eval { @query_parameters = { "bar" => 2 } }

    assert_equal({"foo" => 1, "bar" => 2}, @request.parameters)
    assert_equal({"foo" => 1}, @request.request_parameters)
    assert_equal({"bar" => 2}, @request.query_parameters)
  end

  protected
    def request_method=(method)
      @request.env['REQUEST_METHOD'] = method.to_s.upcase
      @request.request_method(true)
    end
end

class UrlEncodedRequestParameterParsingTest < Test::Unit::TestCase
  def setup
    @query_string = "action=create_customer&full_name=David%20Heinemeier%20Hansson&customerId=1"
    @query_string_with_empty = "action=create_customer&full_name="
    @query_string_with_array = "action=create_customer&selected[]=1&selected[]=2&selected[]=3"
    @query_string_with_amps  = "action=create_customer&name=Don%27t+%26+Does"
    @query_string_with_multiple_of_same_name =
      "action=update_order&full_name=Lau%20Taarnskov&products=4&products=2&products=3"
    @query_string_with_many_equal = "action=create_customer&full_name=abc=def=ghi"
    @query_string_without_equal = "action"
    @query_string_with_many_ampersands =
      "&action=create_customer&&&full_name=David%20Heinemeier%20Hansson"
    @query_string_with_empty_key = "action=create_customer&full_name=David%20Heinemeier%20Hansson&=Save"
  end

  def test_query_string
    assert_equal(
      { "action" => "create_customer", "full_name" => "David Heinemeier Hansson", "customerId" => "1"},
      ActionController::AbstractRequest.parse_query_parameters(@query_string)
    )
  end

  def test_deep_query_string
    expected = {'x' => {'y' => {'z' => '10'}}}
    assert_equal(expected, ActionController::AbstractRequest.parse_query_parameters('x[y][z]=10'))
  end

  def test_deep_query_string_with_array
    assert_equal({'x' => {'y' => {'z' => ['10']}}}, ActionController::AbstractRequest.parse_query_parameters('x[y][z][]=10'))
    assert_equal({'x' => {'y' => {'z' => ['10', '5']}}}, ActionController::AbstractRequest.parse_query_parameters('x[y][z][]=10&x[y][z][]=5'))
  end

  def test_deep_query_string_with_array_of_hash
    assert_equal({'x' => {'y' => [{'z' => '10'}]}}, ActionController::AbstractRequest.parse_query_parameters('x[y][][z]=10'))
    assert_equal({'x' => {'y' => [{'z' => '10', 'w' => '10'}]}}, ActionController::AbstractRequest.parse_query_parameters('x[y][][z]=10&x[y][][w]=10'))
  end

  def test_deep_query_string_with_array_of_hashes_with_one_pair
    assert_equal({'x' => {'y' => [{'z' => '10'}, {'z' => '20'}]}}, ActionController::AbstractRequest.parse_query_parameters('x[y][][z]=10&x[y][][z]=20'))
    assert_equal("10", ActionController::AbstractRequest.parse_query_parameters('x[y][][z]=10&x[y][][z]=20')["x"]["y"].first["z"])
    assert_equal("10", ActionController::AbstractRequest.parse_query_parameters('x[y][][z]=10&x[y][][z]=20').with_indifferent_access[:x][:y].first[:z])
  end

  def test_deep_query_string_with_array_of_hashes_with_multiple_pairs
    assert_equal(
      {'x' => {'y' => [{'z' => '10', 'w' => 'a'}, {'z' => '20', 'w' => 'b'}]}},
      ActionController::AbstractRequest.parse_query_parameters('x[y][][z]=10&x[y][][w]=a&x[y][][z]=20&x[y][][w]=b')
    )
  end

  def test_query_string_with_nil
    assert_equal(
      { "action" => "create_customer", "full_name" => ''},
      ActionController::AbstractRequest.parse_query_parameters(@query_string_with_empty)
    )
  end

  def test_query_string_with_array
    assert_equal(
      { "action" => "create_customer", "selected" => ["1", "2", "3"]},
      ActionController::AbstractRequest.parse_query_parameters(@query_string_with_array)
    )
  end

  def test_query_string_with_amps
    assert_equal(
      { "action" => "create_customer", "name" => "Don't & Does"},
      ActionController::AbstractRequest.parse_query_parameters(@query_string_with_amps)
    )
  end

  def test_query_string_with_many_equal
    assert_equal(
      { "action" => "create_customer", "full_name" => "abc=def=ghi"},
      ActionController::AbstractRequest.parse_query_parameters(@query_string_with_many_equal)
    )
  end

  def test_query_string_without_equal
    assert_equal(
      { "action" => nil },
      ActionController::AbstractRequest.parse_query_parameters(@query_string_without_equal)
    )
  end

  def test_query_string_with_empty_key
    assert_equal(
      { "action" => "create_customer", "full_name" => "David Heinemeier Hansson" },
      ActionController::AbstractRequest.parse_query_parameters(@query_string_with_empty_key)
    )
  end

  def test_query_string_with_many_ampersands
    assert_equal(
      { "action" => "create_customer", "full_name" => "David Heinemeier Hansson"},
      ActionController::AbstractRequest.parse_query_parameters(@query_string_with_many_ampersands)
    )
  end

  def test_unbalanced_query_string_with_array
   assert_equal(
     {'location' => ["1", "2"], 'age_group' => ["2"]},
  ActionController::AbstractRequest.parse_query_parameters("location[]=1&location[]=2&age_group[]=2")
   )
   assert_equal(
     {'location' => ["1", "2"], 'age_group' => ["2"]},
     ActionController::AbstractRequest.parse_request_parameters({'location[]' => ["1", "2"],
  'age_group[]' => ["2"]})
   )
  end

  def test_request_hash_parsing
    query = {
      "note[viewers][viewer][][type]" => ["User", "Group"],
      "note[viewers][viewer][][id]"   => ["1", "2"]
    }

    expected = { "note" => { "viewers"=>{"viewer"=>[{ "id"=>"1", "type"=>"User"}, {"type"=>"Group", "id"=>"2"} ]} } }

    assert_equal(expected, ActionController::AbstractRequest.parse_request_parameters(query))
  end

  def test_parse_params
    input = {
      "customers[boston][first][name]" => [ "David" ],
      "customers[boston][first][url]" => [ "http://David" ],
      "customers[boston][second][name]" => [ "Allan" ],
      "customers[boston][second][url]" => [ "http://Allan" ],
      "something_else" => [ "blah" ],
      "something_nil" => [ nil ],
      "something_empty" => [ "" ],
      "products[first]" => [ "Apple Computer" ],
      "products[second]" => [ "Pc" ],
      "" => [ 'Save' ]
    }

    expected_output =  {
      "customers" => {
        "boston" => {
          "first" => {
            "name" => "David",
            "url" => "http://David"
          },
          "second" => {
            "name" => "Allan",
            "url" => "http://Allan"
          }
        }
      },
      "something_else" => "blah",
      "something_empty" => "",
      "something_nil" => "",
      "products" => {
        "first" => "Apple Computer",
        "second" => "Pc"
      }
    }

    assert_equal expected_output, ActionController::AbstractRequest.parse_request_parameters(input)
  end

  UploadedStringIO = ActionController::UploadedStringIO
  class MockUpload < UploadedStringIO
    def initialize(content_type, original_path, *args)
      self.content_type = content_type
      self.original_path = original_path
      super *args
    end
  end

  def test_parse_params_from_multipart_upload
    file = MockUpload.new('img/jpeg', 'foo.jpg')
    ie_file = MockUpload.new('img/jpeg', 'c:\\Documents and Settings\\foo\\Desktop\\bar.jpg')
    non_file_text_part = MockUpload.new('text/plain', '', 'abc')

    input = {
      "something" => [ UploadedStringIO.new("") ],
      "array_of_stringios" => [[ UploadedStringIO.new("One"), UploadedStringIO.new("Two") ]],
      "mixed_types_array" => [[ UploadedStringIO.new("Three"), "NotStringIO" ]],
      "mixed_types_as_checkboxes[strings][nested]" => [[ file, "String", UploadedStringIO.new("StringIO")]],
      "ie_mixed_types_as_checkboxes[strings][nested]" => [[ ie_file, "String", UploadedStringIO.new("StringIO")]],
      "products[string]" => [ UploadedStringIO.new("Apple Computer") ],
      "products[file]" => [ file ],
      "ie_products[string]" => [ UploadedStringIO.new("Microsoft") ],
      "ie_products[file]" => [ ie_file ],
      "text_part" => [non_file_text_part]
      }

    expected_output =  {
      "something" => "",
      "array_of_stringios" => ["One", "Two"],
      "mixed_types_array" => [ "Three", "NotStringIO" ],
      "mixed_types_as_checkboxes" => {
         "strings" => {
            "nested" => [ file, "String", "StringIO" ]
         },
      },
      "ie_mixed_types_as_checkboxes" => {
         "strings" => {
            "nested" => [ ie_file, "String", "StringIO" ]
         },
      },
      "products" => {
        "string" => "Apple Computer",
        "file" => file
      },
      "ie_products" => {
        "string" => "Microsoft",
        "file" => ie_file
      },
      "text_part" => "abc"
    }

    params = ActionController::AbstractRequest.parse_request_parameters(input)
    assert_equal expected_output, params

    # Lone filenames are preserved.
    assert_equal 'foo.jpg', params['mixed_types_as_checkboxes']['strings']['nested'].first.original_filename
    assert_equal 'foo.jpg', params['products']['file'].original_filename

    # But full Windows paths are reduced to their basename.
    assert_equal 'bar.jpg', params['ie_mixed_types_as_checkboxes']['strings']['nested'].first.original_filename
    assert_equal 'bar.jpg', params['ie_products']['file'].original_filename
  end

  def test_parse_params_with_file
    input = {
      "customers[boston][first][name]" => [ "David" ],
      "something_else" => [ "blah" ],
      "logo" => [ File.new(File.dirname(__FILE__) + "/cgi_test.rb").path ]
    }

    expected_output = {
      "customers" => {
        "boston" => {
          "first" => {
            "name" => "David"
          }
        }
      },
      "something_else" => "blah",
      "logo" => File.new(File.dirname(__FILE__) + "/cgi_test.rb").path,
    }

    assert_equal expected_output, ActionController::AbstractRequest.parse_request_parameters(input)
  end

  def test_parse_params_with_array
    input = { "selected[]" =>  [ "1", "2", "3" ] }

    expected_output = { "selected" => [ "1", "2", "3" ] }

    assert_equal expected_output, ActionController::AbstractRequest.parse_request_parameters(input)
  end

  def test_parse_params_with_non_alphanumeric_name
    input     = { "a/b[c]" =>  %w(d) }
    expected  = { "a/b" => { "c" => "d" }}
    assert_equal expected, ActionController::AbstractRequest.parse_request_parameters(input)
  end

  def test_parse_params_with_single_brackets_in_middle
    input     = { "a/b[c]d" =>  %w(e) }
    expected  = { "a/b" => {} }
    assert_equal expected, ActionController::AbstractRequest.parse_request_parameters(input)
  end

  def test_parse_params_with_separated_brackets
    input     = { "a/b@[c]d[e]" =>  %w(f) }
    expected  = { "a/b@" => { }}
    assert_equal expected, ActionController::AbstractRequest.parse_request_parameters(input)
  end

  def test_parse_params_with_separated_brackets_and_array
    input     = { "a/b@[c]d[e][]" =>  %w(f) }
    expected  = { "a/b@" => { }}
    assert_equal expected , ActionController::AbstractRequest.parse_request_parameters(input)
  end

  def test_parse_params_with_unmatched_brackets_and_array
    input     = { "a/b@[c][d[e][]" =>  %w(f) }
    expected  = { "a/b@" => { "c" => { }}}
    assert_equal expected, ActionController::AbstractRequest.parse_request_parameters(input)
  end

  def test_parse_params_with_nil_key
    input = { nil => nil, "test2" => %w(value1) }
    expected = { "test2" => "value1" }
    assert_equal expected, ActionController::AbstractRequest.parse_request_parameters(input)
  end

  def test_parse_params_with_array_prefix_and_hashes
    input = { "a[][b][c]" => %w(d) }
    expected = {"a" => [{"b" => {"c" => "d"}}]}
    assert_equal expected, ActionController::AbstractRequest.parse_request_parameters(input)
  end

  def test_parse_params_with_complex_nesting
    input = { "a[][b][c][][d][]" => %w(e) }
    expected = {"a" => [{"b" => {"c" => [{"d" => ["e"]}]}}]}
    assert_equal expected, ActionController::AbstractRequest.parse_request_parameters(input)
  end
end

class MultipartRequestParameterParsingTest < Test::Unit::TestCase
  FIXTURE_PATH = File.dirname(__FILE__) + '/../fixtures/multipart'

  def test_single_parameter
    params = process('single_parameter')
    assert_equal({ 'foo' => 'bar' }, params)
  end

  def test_bracketed_param
    assert_equal({ 'foo' => { 'baz' => 'bar'}}, process('bracketed_param'))
  end

  def test_text_file
    params = process('text_file')
    assert_equal %w(file foo), params.keys.sort
    assert_equal 'bar', params['foo']

    file = params['file']
    assert_kind_of StringIO, file
    assert_equal 'file.txt', file.original_filename
    assert_equal "text/plain", file.content_type
    assert_equal 'contents', file.read
  end

  def test_boundary_problem_file
    params = process('boundary_problem_file')
    assert_equal %w(file foo), params.keys.sort

    file = params['file']
    foo  = params['foo']

    assert_kind_of Tempfile, file

    assert_equal 'file.txt', file.original_filename
    assert_equal "text/plain", file.content_type

    assert_equal 'bar', foo
  end

  def test_large_text_file
    params = process('large_text_file')
    assert_equal %w(file foo), params.keys.sort
    assert_equal 'bar', params['foo']

    file = params['file']

    assert_kind_of Tempfile, file

    assert_equal 'file.txt', file.original_filename
    assert_equal "text/plain", file.content_type
    assert ('a' * 20480) == file.read
  end

  uses_mocha "test_no_rewind_stream" do
    def test_no_rewind_stream
      # Ensures that parse_multipart_form_parameters works with streams that cannot be rewound
      file = File.open(File.join(FIXTURE_PATH, 'large_text_file'), 'rb')
      file.expects(:rewind).raises(Errno::ESPIPE)
      params = ActionController::AbstractRequest.parse_multipart_form_parameters(file, 'AaB03x', file.stat.size, {})
      assert_not_equal 0, file.pos  # file was not rewound after reading
    end
  end

  def test_binary_file
    params = process('binary_file')
    assert_equal %w(file flowers foo), params.keys.sort
    assert_equal 'bar', params['foo']

    file = params['file']
    assert_kind_of StringIO, file
    assert_equal 'file.csv', file.original_filename
    assert_nil file.content_type
    assert_equal 'contents', file.read

    file = params['flowers']
    assert_kind_of StringIO, file
    assert_equal 'flowers.jpg', file.original_filename
    assert_equal "image/jpeg", file.content_type
    assert_equal 19512, file.size
    #assert_equal File.read(File.dirname(__FILE__) + '/../../../activerecord/test/fixtures/flowers.jpg'), file.read
  end

  def test_mixed_files
    params = process('mixed_files')
    assert_equal %w(files foo), params.keys.sort
    assert_equal 'bar', params['foo']

    # Ruby CGI doesn't handle multipart/mixed for us.
    files = params['files']
    assert_kind_of String, files
    files.force_encoding('ASCII-8BIT') if files.respond_to?(:force_encoding)
    assert_equal 19756, files.size
  end

  private
    def process(name)
      File.open(File.join(FIXTURE_PATH, name), 'rb') do |file|
        params = ActionController::AbstractRequest.parse_multipart_form_parameters(file, 'AaB03x', file.stat.size, {})
        assert_equal 0, file.pos  # file was rewound after reading
        params
      end
    end
end

class XmlParamsParsingTest < Test::Unit::TestCase
  def test_hash_params
    person = parse_body("<person><name>David</name></person>")[:person]
    assert_kind_of Hash, person
    assert_equal 'David', person['name']
  end

  def test_single_file
    person = parse_body("<person><name>David</name><avatar type='file' name='me.jpg' content_type='image/jpg'>#{ActiveSupport::Base64.encode64('ABC')}</avatar></person>")

    assert_equal "image/jpg", person['person']['avatar'].content_type
    assert_equal "me.jpg", person['person']['avatar'].original_filename
    assert_equal "ABC", person['person']['avatar'].read
  end

  def test_multiple_files
    person = parse_body(<<-end_body)
      <person>
        <name>David</name>
        <avatars>
          <avatar type='file' name='me.jpg' content_type='image/jpg'>#{ActiveSupport::Base64.encode64('ABC')}</avatar>
          <avatar type='file' name='you.gif' content_type='image/gif'>#{ActiveSupport::Base64.encode64('DEF')}</avatar>
        </avatars>
      </person>
    end_body

    assert_equal "image/jpg", person['person']['avatars']['avatar'].first.content_type
    assert_equal "me.jpg", person['person']['avatars']['avatar'].first.original_filename
    assert_equal "ABC", person['person']['avatars']['avatar'].first.read

    assert_equal "image/gif", person['person']['avatars']['avatar'].last.content_type
    assert_equal "you.gif", person['person']['avatars']['avatar'].last.original_filename
    assert_equal "DEF", person['person']['avatars']['avatar'].last.read
  end

  private
    def parse_body(body)
      env = { 'rack.input'     => StringIO.new(body),
              'CONTENT_TYPE'   => 'application/xml',
              'CONTENT_LENGTH' => body.size.to_s }
      ActionController::RackRequest.new(env).request_parameters
    end
end

class LegacyXmlParamsParsingTest < XmlParamsParsingTest
  private
    def parse_body(body)
      env = { 'rack.input'              => StringIO.new(body),
              'HTTP_X_POST_DATA_FORMAT' => 'xml',
              'CONTENT_LENGTH'          => body.size.to_s }
      ActionController::RackRequest.new(env).request_parameters
    end
end

class JsonParamsParsingTest < Test::Unit::TestCase
  def test_hash_params_for_application_json
    person = parse_body({:person => {:name => "David"}}.to_json,'application/json')[:person]
    assert_kind_of Hash, person
    assert_equal 'David', person['name']
  end

  def test_hash_params_for_application_jsonrequest
    person = parse_body({:person => {:name => "David"}}.to_json,'application/jsonrequest')[:person]
    assert_kind_of Hash, person
    assert_equal 'David', person['name']
  end

  private
    def parse_body(body,content_type)
      env = { 'rack.input'     => StringIO.new(body),
              'CONTENT_TYPE'   => content_type,
              'CONTENT_LENGTH' => body.size.to_s }
      ActionController::RackRequest.new(env).request_parameters
    end
end
