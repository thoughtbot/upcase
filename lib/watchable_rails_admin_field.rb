class WatchableRailsAdminField < SimpleDelegator
  def initialize(decorated_field)
    super(decorated_field)
  end

  def associated_collection(type)
    super(type).sort
  end

  def polymorphic_type_collection
    super.select do |(_, class_name)|
      class_name.constantize.superclass == ApplicationRecord
    end
  end
end
