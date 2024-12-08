module BucklerHelper
  def character_select_tag(name, options = {})
    if options.delete(:include_any)
      options[:include_blank] = "Any Character"
    end
    option_tags = options_from_collection_for_select(Character, :id, :human_name, options.delete(:selected))
    select_tag(name, option_tags, options)
  end

  def control_type_select_tag(name, options = {})
    if options.delete(:include_any)
      options[:include_blank] = "Any Control Type"
    end
    option_tags = options_from_collection_for_select(ControlType, :id, :to_s, options.delete(:selected))
    select_tag(name, option_tags, options)
  end

  def battle_type_select_tag(name, options = {})
    if options.delete(:include_any)
      options[:include_blank] = "Any Battle Type"
    end
    option_tags = options_from_collection_for_select(BattleType, :id, :human_name, options.delete(:selected))
    select_tag(name, option_tags, options)
  end
end
