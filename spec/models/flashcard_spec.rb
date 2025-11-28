require "rails_helper"

RSpec.describe Flashcard do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:prompt) }
  it { should validate_presence_of(:answer) }

  it { should belong_to(:deck) }
  it { should have_many(:attempts) }

  describe "#attempts" do
    it "orders by created_at, most recent first" do
      flashcard = create(:flashcard)
      older_attempt = create(:attempt, flashcard: flashcard)
      newer_attempt = create(:attempt, flashcard: flashcard)

      expect(flashcard.attempts).to eq([newer_attempt, older_attempt])
    end
  end

  describe "#next" do
    context "when there are more flashcards" do
      it "returns the next flashcard" do
        deck = create(:deck)
        first_flashcard, second_flashcard = create_list(
          :flashcard,
          2,
          deck: deck
        )

        expect(first_flashcard.next).to eq(second_flashcard)
      end
    end

    context "when there are no more flashcards" do
      it "returns nil" do
        flashcard = create(:flashcard)

        expect(flashcard.next).to be_nil
      end
    end
  end

  describe "#deck_title" do
    it "returns the deck title" do
      deck = build_stubbed(:deck)
      flashcard = build_stubbed(:flashcard, deck: deck)

      expect(flashcard.deck_title).to eq(deck.title)
    end
  end

  describe "#most_recent_attempt_for" do
    context "the user has attempted the flashcard" do
      it "returns the most recent attempt" do
        user = create(:user)
        flashcard = create(:flashcard)
        attempts = create_list(:attempt, 2, flashcard: flashcard, user: user)

        expect(flashcard.most_recent_attempt_for(user)).to eq(attempts.last)
      end
    end

    context "the user has yet to attempt the flashcard" do
      it "should return a null attempt" do
        user = build_stubbed(:user)
        flashcard = create(:flashcard)

        expect(flashcard.most_recent_attempt_for(user)).to be_a(NullAttempt)
      end
    end
  end

  describe "#saved_for_review?" do
    context "when the user saved it for review" do
      it "returns true" do
        flashcard = create(:flashcard)
        attempt = create(
          :attempt,
          flashcard: flashcard,
          confidence: Attempt::LOW_CONFIDENCE
        )
        user = attempt.user

        expect(flashcard.saved_for_review?(user)).to be_truthy
      end
    end

    context "when the user did not save it for review" do
      it "returns false" do
        flashcard = create(:flashcard)
        attempt = create(
          :attempt,
          flashcard: flashcard,
          confidence: Attempt::HIGH_CONFIDENCE
        )
        user = attempt.user

        expect(flashcard.saved_for_review?(user)).to be_falsey
      end
    end
  end

  describe "#search_visible?" do
    context "if the deck is published" do
      it "returns true" do
        deck = build_stubbed(:deck, published: true)
        flashcard = Flashcard.new(deck: deck)

        expect(flashcard).to be_search_visible
      end
    end

    context "if the deck is not published" do
      it "returns false" do
        deck = build_stubbed(:deck, published: false)
        flashcard = Flashcard.new(deck: deck)

        expect(flashcard).not_to be_search_visible
      end
    end
  end
end
