require 'spec_helper'

describe Teacher do
  describe ".by_name" do
    let!(:bob) { create(:teacher, name: "Bob Doe") }
    let!(:albert) { create(:teacher, name: "Albert Doe") }
    subject { Teacher.by_name }

    it "sorts the result by name" do
      subject.should == [albert, bob]
    end
  end

  describe "#image_name" do
    it 'returns image name in proper format' do
      teacher = build_stubbed(:teacher, name: 'Arun Agrawal')

      expect(teacher.image_name).to eq('aagrawal')
    end
  end
end
