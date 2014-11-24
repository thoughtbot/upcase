class AttributesCopier
  def initialize(source:, target:, attributes:)
    @attributes = attributes
    @source = source
    @target = target
  end

  def copy_present_attributes
    attributes.each do |attribute|
      if source.send(attribute).present?
        target.public_send "#{attribute}=", source.send(attribute)
      end
    end
  end

  private

  attr_reader :attributes, :source, :target
end
