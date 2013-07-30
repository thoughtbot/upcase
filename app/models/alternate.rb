class Alternate
  include ActiveModel::Conversion

  attr_reader :key, :offering

  def initialize(key, offering)
    @key = key
    @offering = offering
  end

  def ==(other)
    other.is_a?(Alternate) && other.key == key && other.offering == offering
  end

  def cities
    other_offering.collect(&:city).to_sentence(words_connector: ' or ')
  end

  private

  def other_offering
    if key == 'in_person_workshop'
      offering.active_sections
    else
      offering.alternates.first.offering.active_sections
    end
  end
end
