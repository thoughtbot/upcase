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
      @relation.
        includes(:replies).
        references(:replies).
        where(<<-SQL, @user.id)
          beta_replies.user_id <> ?
          OR beta_replies.user_id IS NULL
        SQL
    end
  end
end
