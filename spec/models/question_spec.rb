require "rails_helper"

describe Question do
  it { should validate_presence_of(:prompt) }
  it { should validate_presence_of(:answer) }

  it { should belong_to(:quiz) }

  describe "#next" do
    context "when there are more questions" do
      it "returns the next question" do
        quiz = create(:quiz)
        first_question, second_question = create_list(:question, 2, quiz: quiz)

        expect(first_question.next).to eq(second_question)
      end
    end

    context "when there are no more questions" do
      it "returns nil" do
        question = create(:question)

        expect(question.next).to be_nil
      end
    end
  end
end
