class RemoveThisWeekInOpenSourceContent < ActiveRecord::Migration
  def up
    @topic = Topic.find_by_name("this week in open source")
    if @topic
      @topic.articles.destroy_all
      @topic.destroy
    end
  end

  def down
  end
end
