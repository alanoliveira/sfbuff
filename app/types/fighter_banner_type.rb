class FighterBannerType < ActiveModel::Type::Value
  def cast_value(value)
    case value
    when Hash then BucklerApiGateway::Mappers::FighterBanner.new(value)
    else value
    end
  end

  def serialize(value)
    value.as_json
  end

  def type
    :fighter_banner
  end
end
