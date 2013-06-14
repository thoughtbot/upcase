module AdwordsHelper
  def adwords_conversion_tracker(value)
    if value.present?
      <<-JS.strip_heredoc.html_safe
        <script type="text/javascript">
        /* <![CDATA[ */
        var google_conversion_id = 983769411;
        var google_conversion_language = "en";
        var google_conversion_format = "3";
        var google_conversion_color = "f5f5f0";
        var google_conversion_label = "h6fpCI3R6QkQw8KM1QM";
        var google_conversion_value = #{value};
        /* ]]> */
        </script>
        <script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
        </script>
        <noscript>
        <div style="display:inline;">
        <img height="1" width="1" style="border-style:none;" alt="" src="//www.googleadservices.com/pagead/conversion/983769411/?value=#{flash[:purchase_paid_price]}&amp;label=h6fpCI3R6QkQw8KM1QM&amp;guid=ON&amp;script=0"/>
        </div>
        </noscript>
      JS
    end
  end
end

