require 'spec_helper'

describe Loader do

  context 'import_articles_and_topics' do

    before do
      base_post = {title: "", published_at: Time.now - 5.days,
        body_html: "test", tumblr_url: "test", tags: []}

      posts = [
        base_post.merge(title: "test1", tags: ["test_tag1"]),
        base_post.merge(title: "test2", tags: ["test_tag1", "test_tag2"]),
        base_post.merge(title: "test3", tags: ["this week in open source", "test_tag3"]),
        base_post.merge(title: "test4", tags: ["test_tag4"])
      ]
      Loader.import_articles_and_topics posts
    end

    it "saves the right articles" do
      Article.find_by_title("test1").should be_present
      Article.find_by_title("test2").should be_present
      Article.find_by_title("test3").should_not be_present
      Article.find_by_title("test4").should be_present
    end

    it "saves the right topics" do
      Topic.find_by_name("test_tag1").should be_present
      Topic.find_by_name("test_tag2").should be_present
      Topic.find_by_name("test_tag3").should_not be_present
      Topic.find_by_name("test_tag4").should be_present
    end

    it "saves the right associations" do
      Article.find_by_title("test1").topics.map(&:name).should == ["test_tag1"]
      Article.find_by_title("test2").topics.map(&:name).should == ["test_tag1", "test_tag2"]
      Topic.find_by_name("test_tag1").articles.count.should == 2
      Topic.find_by_name("test_tag2").articles.count.should == 1
    end
  end
end
