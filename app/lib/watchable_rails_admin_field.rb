class WatchableRailsAdminField < SimpleDelegator
  def initialize(decorated_field)
    super
  end

  def associated_collection(type)
    super.sort
  end

  def polymorphic_type_collection
    super.select do |(_, class_name)|
      class_name.constantize.superclass == ApplicationRecord
    end
  end
end
