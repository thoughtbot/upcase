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
end
