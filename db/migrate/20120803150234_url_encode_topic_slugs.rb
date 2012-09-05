class UrlEncodeTopicSlugs < ActiveRecord::Migration
  def up
    topics = select_all("select id, name from topics")
    topics.each do |topic|
      update "update topics set slug = '#{CGI::escape(topic['name']).downcase}' where id = #{topic['id']}"
    end
  end

  def down
    topics = select_all("select id, name from topics")
    topics.each do |topic|
      update "update topics set slug = '#{CGI::unescape(topic['name']).parameterize}' where id = #{topic['id']}"
    end
  end
end
