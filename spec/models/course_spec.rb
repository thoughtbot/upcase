require 'spec_helper'

describe Course do
  it { should belong_to(:audience) }
  it { should validate_presence_of(:audience_id) }

  it { should have_many(:classifications) }
  it { should have_many(:topics).through(:classifications) }

  context "#to_param" do
    subject { create(:course) }
    it "returns the id and parameterized name" do
      subject.to_param.should == "#{subject.id}-#{subject.name.parameterize}"
    end
  end

  describe '#find_courses_by_topics' do
    it 'includes courses for the given topics' do
      topic_1 = create(:topic, name: 'ruby')
      topic_2 = create(:topic, name: 'rubygems')
      course = create(:course, public: true)
      course_not_in_topics = create(:course)

      found_topics = [topic_1, topic_2]
      found_topics.each { |topic| topic.courses << course }

      Course.find_courses_by_topics(found_topics).should include(course)
      Course.find_courses_by_topics(found_topics).should_not include(course_not_in_topics)
    end
  end

  describe "#for_topic" do
    it "includes only courses for the given topic" do
      topic = create(:topic)
      in_topic = create(:course)
      topic.courses << in_topic
      not_in_topic = create(:course)

      Course.for_topic(topic).should include in_topic
      Course.for_topic(topic).should_not include not_in_topic
    end
  end
end
