class Test::Unit::TestCase
  # assert_form posts_url, :put do
  #   assert_text_field :post, :title
  #   assert_text_area  :post, :body
  #   assert_submit
  # end
  def assert_form(url, http_method = :post)
    http_method, hidden_http_method = form_http_method(http_method)
    assert_select "form[action=?][method=#{http_method}]", url do
      if hidden_http_method
        assert_select "input[type=hidden][name=_method][value=#{hidden_http_method}]"
      end
      if block_given?
        yield
      end
    end
  end

  def form_http_method(http_method)
    http_method = http_method.to_s
    if http_method == "post" || http_method == "get"
      return http_method, nil
    else
      return "post", http_method
    end
  end

  def assert_submit
    assert_select "input[type=submit]"
  end

  # TODO: default to test the label, provide :label => false option
  def assert_text_field(model, attribute)
    assert_select "input[type=text][name=?]",
                  "#{model.to_s}[#{attribute.to_s}]"
  end

  # TODO: default to test the label, provide :label => false option
  def assert_text_area(model, attribute)
    assert_select "textarea[name=?]",
                  "#{model.to_s}[#{attribute.to_s}]"
  end

  # TODO: default to test the label, provide :label => false option
  def assert_password_field(model, attribute)
    assert_select "input[type=password][name=?]",
                  "#{model.to_s}[#{attribute.to_s}]"
  end

  # TODO: default to test the label, provide :label => false option
  def assert_radio_button(model, attribute)
    assert_select "input[type=radio][name=?]",
                  "#{model.to_s}[#{attribute.to_s}]"
  end

  def assert_label(model, attribute)
    label = "#{model.to_s.underscore}_#{model.to_s.underscore}"
    assert_select "label[for=?]", label
  end
end
