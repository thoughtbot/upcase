class Test::Unit::TestCase
 def self.should_have_form(opts)
    model = opts[:model] || self.name.gsub(/ControllerTest$/, '').singularize.downcase
    model = model[model.rindex('::')+2..model.size] if model.include?('::')
    http_method = opts[:method].nil? ? 'post' : opts[:method].to_s
    should "have a #{model} form" do
      assert_select "form[action=?][method=#{http_method}]", eval(opts[:action]) do
        opts[:fields].each do |attribute, type|
          attribute = attribute.is_a?(Symbol) ? "#{model}[#{attribute.to_s}]" : attribute
          assert_select "input[type=#{type.to_s}][name=?]", attribute
        end
        assert_select "input[type=submit]"
      end
    end
  end
end
