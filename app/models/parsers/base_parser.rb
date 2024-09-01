class Parsers::BaseParser
  def self.parse(raw_data:)
    new(raw_data:).parse
  end

  attr_reader :raw_data

  def initialize(raw_data:)
    @raw_data = raw_data
  end
end
