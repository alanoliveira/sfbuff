class JsonArray < ActiveRecord::Type::Json
  attr_reader :subtype

  def initialize(subtype)
    @subtype = subtype
  end

  def serialize(value)
    super value&.map { subtype.serialize it }
  end

  def deserialize(value)
    super(value)&.map { subtype.deserialize it }
  end
end

ActiveSupport.on_load :active_record do
  ActiveRecord::Type.add_modifier({ json_array: true }, JsonArray)
end
