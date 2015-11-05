module Beta
  class VisibleOfferQuery
    include Enumerable

    def initialize(relation, user:)
      @relation = relation
      @user = user
    end

    def each(&block)
      offers.each(&block)
    end

    private

    def offers
      @offers ||= find_offers
    end

    def find_offers
      if completed_trails?
        offers_without_replies
      else
        Offer.none
      end
    end

    def completed_trails?
      @user.statuses.by_type(Trail).completed.any?
    end

    def offers_without_replies
      @relation.where(<<-SQL, @user.id)
        NOT EXISTS (
          SELECT NULL
          FROM beta_replies
          WHERE beta_replies.offer_id = beta_offers.id
          AND beta_replies.user_id = ?
        )
      SQL
    end
  end
end
