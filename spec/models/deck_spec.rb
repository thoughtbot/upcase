require "rails_helper"

describe Deck do
  it { should validate_presence_of(:title) }

  it { should have_many(:flashcards).dependent(:destroy) }

  it { should have_many(:attempts).order(created_at: :desc) }

  describe ".published" do
    it "returns only decks explicitly marked as published" do
      published_deck = create(:deck, published: true)
      _unpublished_deck = create(:deck, published: false)

      expect(Deck.published).to eq([published_deck])
    end
  end

  describe ".most_recent_first" do
    it "returns the decks with the most recent first" do
      create(:deck, title: "older", created_at: 5.days.ago)
      create(:deck, title: "newer", created_at: 1.day.ago)

      result = Deck.most_recent_first.map(&:title)

      expect(result).to eq(%w(newer older))
    end
  end

  describe "#first_flashcard" do
    it "returns the first flashcard" do
      deck = create(:deck)
      flashcards = create_list(:flashcard, 2, deck: deck)

      expect(deck.first_flashcard).to eq(flashcards.first)
    end
  end

  describe "#flashcards" do
    it "returns the flashcards in position order" do
      deck = create(:deck)

      older_flashcard = create(:flashcard, deck: deck, position: 2)
      newer_flashcard = create(:flashcard, deck: deck, position: 1)

      expect(deck.flashcards).to match([newer_flashcard, older_flashcard])
    end
  end

  describe "#last_attempted_by" do
    let(:user)       { create(:user) }
    let(:deck)       { create(:deck) }
    let(:flashcards) { create_list(:flashcard, 2, deck: deck) }

    context "the user has attempted a flashcard in the deck" do
      it "returns the time of the most recent attempt" do
        first_attempt = create(:attempt, flashcard: flashcards.first, user: user, created_at: 15.minutes.ago)
        second_attempt = create(:attempt, flashcard: flashcards.first, user: user, created_at: 45.minutes.ago)
        third_attempt = create(:attempt, flashcard: flashcards.second, user: user, created_at: 2.minutes.ago)
        fourth_attempt = create(:attempt, flashcard: flashcards.second, user: user, created_at: 10.minutes.ago)

        expect(deck.last_attempted_by(user)).to be_within(1.second).of third_attempt.created_at
      end
    end

    context "the user has yet to attempt a flashcard in the deck" do
      it "returns nil" do
        expect(deck.last_attempted_by(user)).to be_nil
      end
    end
  end

  describe "#length" do
    it "returns the number of flashcards the deck has" do
      deck = create(:deck)
      create(:flashcard, deck: deck)
      create(:flashcard, deck: deck)

      result = deck.length

      expect(result).to eq(2)
    end
  end

  describe "#most_recent_attempt_for" do
    let(:user)       { create(:user) }
    let(:deck)       { create(:deck) }
    let(:flashcards) { create_list(:flashcard, 2, deck: deck) }

    context "the user has attempted a flashcard in the deck" do
      it "returns the most recent attempt" do
        first_attempt = create(:attempt, flashcard: flashcards.first, user: user, created_at: 15.minutes.ago)
        second_attempt = create(:attempt, flashcard: flashcards.first, user: user, created_at: 45.minutes.ago)
        third_attempt = create(:attempt, flashcard: flashcards.second, user: user, created_at: 2.minutes.ago)
        fourth_attempt = create(:attempt, flashcard: flashcards.second, user: user, created_at: 10.minutes.ago)

        expect(deck.most_recent_attempt_for(user)).to eq(third_attempt)
      end
    end

    context "the user has yet to attempt a flashcard in the deck" do
      it "returns a null attempt" do
        expect(deck.most_recent_attempt_for(user)).to be_a(NullAttempt)
      end
    end
  end
end
