require "rails_helper"

describe DeckList do
  describe "#last_attempted_at" do
    let(:user)       { create(:user) }
    let(:deck)       { create(:deck) }
    let(:flashcards) { create_list(:flashcard, 2, deck: deck) }

    context "the user has attempted a flashcard in the deck" do
      it "returns the time of the most recent attempt" do
        first_attempt = create(:attempt,
                               flashcard: flashcards.first,
                               user: user,
                               updated_at: 15.minutes.ago)
        second_attempt = create(:attempt,
                                flashcard: flashcards.first,
                                user: user,
                                updated_at: 45.minutes.ago)
        third_attempt = create(:attempt,
                               flashcard: flashcards.second,
                               user: user,
                               updated_at: 2.minutes.ago)
        fourth_attempt = create(:attempt,
                                flashcard: flashcards.second,
                                user: user,
                                updated_at: 10.minutes.ago)

        deck_list = DeckList.new(user)

        expect(deck_list.last_attempted_at(deck)).
          to be_within(1.second).of third_attempt.updated_at
      end
    end

    context "the user has yet to attempt a flashcard in the deck" do
      it "returns nil" do
        deck_list = DeckList.new(user)

        expect(deck_list.last_attempted_at(user)).to be_nil
      end
    end
  end
end
