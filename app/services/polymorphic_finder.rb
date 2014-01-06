# Finds one of several possible polymorphic members from params based on a list
# of relations to look in and attributes to look for.
#
# Each polymorphic member will be tried in turn. If an ID is present that
# doesn't correspond to an existing row, or if none of the possible IDs are
# present in the params, an exception will be raised.
class PolymorphicFinder
  def initialize(finder)
    @finder = finder
  end

  def self.finding(*args)
    new(NullFinder.new).finding(*args)
  end

  def finding(relation, attribute, param_names)
    new_finder = param_names.inject(@finder) do |fallback, param_name|
      Finder.new(relation, attribute, param_name, fallback)
    end

    self.class.new(new_finder)
  end

  def find(params)
    @finder.find(params)
  end

  private

  class Finder
    def initialize(relation, attribute, param_name, fallback)
      @relation = relation
      @attribute = attribute
      @param_name = param_name
      @fallback = fallback
    end

    def find(params)
      if id = params[@param_name]
        @relation.where(@attribute => id).first!
      else
        @fallback.find(params)
      end
    end
  end

  class NullFinder
    def find(params)
      raise(
        ActiveRecord::RecordNotFound,
        "Can't find a polymorphic record without an ID: #{params.inspect}"
      )
    end
  end

  private_constant :Finder, :NullFinder
end
