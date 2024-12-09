class JsonArrayWrapperType < ActiveRecord::Type::Json
  attr_reader :subtype, :supertype

  def initialize(subtype)
    @subtype = subtype
    super()
  end

  def serialize(value)
    super(value&.map { subtype.serialize _1 })
  end

  def deserialize(value)
    super&.map { subtype.deserialize _1 }
  end

  private

  def cast_value(value)
    value&.map { subtype.cast _1 }
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Type.add_modifier({ json_array_wrapper: true }, JsonArrayWrapperType)
end
