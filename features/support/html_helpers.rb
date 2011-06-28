module HtmlHelpers
  def inside(*args, &block)
    dom = "##{dom_id(*args)}"
    within dom, &block
  end
end

World(HtmlHelpers)
