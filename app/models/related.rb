class Related
  def initialize(item)
    @item = item
  end

  def video_tutorials
    @item.video_tutorials.only_active.by_position
  end

  def products
    @item.products.active.ordered
  end

  def topics
    @item.topics
  end

  def to_partial_path
    'relateds/related'
  end
end
