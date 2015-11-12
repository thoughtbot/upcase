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
      if @user.has_completed_trails?
        active_offers_without_replies
      else
        Offer.none
      end
    end

    def active_offers_without_replies
      @relation.active.where(<<-SQL, @user.id)
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
