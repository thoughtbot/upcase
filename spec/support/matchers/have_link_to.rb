RSpec::Matchers.define :have_link_to do |target|
  match do |rendered|
    expect(rendered).to have_css("a[href='#{url_for(target)}']")
  end

  failure_message do |rendered|
    "Expected link to #{url_for(target)}, but found #{found(rendered)}"
  end

  def found(rendered)
    if links(rendered).empty?
      "no links."
    else
      "links:\n#{links(rendered).join("\n")}"
    end
  end

  def links(rendered)
    Capybara.
      string(rendered).
      all("a").
      map { |link| link["href"] }.
      compact
  end
end
