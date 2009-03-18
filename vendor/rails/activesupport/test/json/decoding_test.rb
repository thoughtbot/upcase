# encoding: UTF-8
require 'abstract_unit'

class TestJSONDecoding < Test::Unit::TestCase
  TESTS = {
    %q({"returnTo":{"\/categories":"\/"}})        => {"returnTo" => {"/categories" => "/"}},
    %q({returnTo:{"\/categories":"\/"}})          => {"returnTo" => {"/categories" => "/"}},
    %q({"return\\"To\\":":{"\/categories":"\/"}}) => {"return\"To\":" => {"/categories" => "/"}},
    %q({"returnTo":{"\/categories":1}})          => {"returnTo" => {"/categories" => 1}},
    %({"returnTo":[1,"a"]})                    => {"returnTo" => [1, "a"]},
    %({"returnTo":[1,"\\"a\\",", "b"]})        => {"returnTo" => [1, "\"a\",", "b"]},
    %({a: "'", "b": "5,000"})                  => {"a" => "'", "b" => "5,000"},
    %({a: "a's, b's and c's", "b": "5,000"})   => {"a" => "a's, b's and c's", "b" => "5,000"},
    # multibyte
    %({"matzue": "松江", "asakusa": "浅草"}) => {"matzue" => "松江", "asakusa" => "浅草"},
    %({a: "2007-01-01"})                       => {'a' => Date.new(2007, 1, 1)}, 
    %({a: "2007-01-01 01:12:34 Z"})            => {'a' => Time.utc(2007, 1, 1, 1, 12, 34)}, 
    # no time zone
    %({a: "2007-01-01 01:12:34"})              => {'a' => "2007-01-01 01:12:34"}, 
    # needs to be *exact*
    %({a: " 2007-01-01 01:12:34 Z "})          => {'a' => " 2007-01-01 01:12:34 Z "},
    %({a: "2007-01-01 : it's your birthday"})  => {'a' => "2007-01-01 : it's your birthday"},
    %([])    => [],
    %({})    => {},
    %(1)     => 1,
    %("")    => "",
    %("\\"") => "\"",
    %(null)  => nil,
    %(true)  => true,
    %(false) => false,
    %q("http:\/\/test.host\/posts\/1") => "http://test.host/posts/1",
    %q("\u003cunicode\u0020escape\u003e") => "<unicode escape>",
    %q("\\\\u0020skip double backslashes") => "\\u0020skip double backslashes",
    %q({a: "\u003cbr /\u003e"}) => {'a' => "<br />"},
    %q({b:["\u003ci\u003e","\u003cb\u003e","\u003cu\u003e"]}) => {'b' => ["<i>","<b>","<u>"]}
  }
  
  TESTS.each do |json, expected|
    define_method :"test_json_decoding_#{json}" do
      assert_nothing_raised do
        assert_equal expected, ActiveSupport::JSON.decode(json)
      end
    end
  end
  
  def test_failed_json_decoding
    assert_raise(ActiveSupport::JSON::ParseError) { ActiveSupport::JSON.decode(%({: 1})) }
  end
end
