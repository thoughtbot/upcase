module CucumberJavascript
  MOCK_DEBUG = %{
    console = {
      log: function (text) {
        Ruby.Rails.logger().debug('*** Javascript: ' + text + ' ***');
      }
    };
  }

  MOCK_SET_TIMEOUT = %{
    setTimeout = function() {
      arguments[0].call();
    };
  }

  MOCK_JQUERY_FADE = %{
    (function() {
      $.fn.fadeOut = function() {
        if($.isFunction(arguments[0])) {
          arguments[0].call();
        } else if($.isFunction(arguments[1])) {
          arguments[1].call();
        }
        return this;
      };
      $.fn.fadeIn = function() {
        if($.isFunction(arguments[0])) {
          arguments[0].call();
        } else if($.isFunction(arguments[1])) {
          arguments[1].call();
        }
        return this;
      };
    })();
  }

  MOCK_ENVJS = %{
    /* fixes the .value property on textareas in env.js */
    var extension = {
      get value() { return this.innerText; },
      set value(newValue) { this.innerText = newValue; }
    };
    var valueGetter = extension.__lookupGetter__('value');
    HTMLTextAreaElement.prototype.__defineGetter__('value', valueGetter);
    var valueSetter = extension.__lookupSetter__('value');
    HTMLTextAreaElement.prototype.__defineSetter__('value', valueSetter);
  }
  MOCK_JAVASCRIPT = (MOCK_SET_TIMEOUT + MOCK_DEBUG + MOCK_ENVJS).freeze
  MOCK_JQUERY = MOCK_JQUERY_FADE.freeze
end

Before('@javascript') do
  @__custom_javascript = []
  Capybara.current_session.driver.rack_mock_session.after_request do
    new_body = Capybara.current_session.driver.response.body
    new_body.gsub!("<head>",
                   %{"<head>
                     <script type="text/javascript">
                       #{CucumberJavascript::MOCK_JAVASCRIPT}
                     </script>})
    new_body.sub!("</body>",
                  %{<script type="text/javascript">
                    #{CucumberJavascript::MOCK_JQUERY}
                    #{@__custom_javascript.join}
                    </script>
                    </body>})
    new_body.gsub!(%r{<script src="http://[^"]+" type="text/javascript"></script>}, '')
    Capybara.current_session.driver.response.instance_variable_set('@body', new_body)
  end
end
