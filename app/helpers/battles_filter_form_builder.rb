class BattlesFilterFormBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {}, &block)
    text = @template.translate(method, scope: "attributes") if text.nil? || text.is_a?(Hash)
    super
  end

  def character_select(name, **opts)
    opts[:selected] = @template.params[name] if opts[:selected].blank?
    @template.character_select_tag(name, **opts)
  end

  def control_type_select(name, **opts)
    opts[:selected] = @template.params[name] if opts[:selected].blank?
    @template.control_type_select_tag(name, **opts)
  end

  def battle_type_select(name, **opts)
    opts[:selected] = @template.params[name] if opts[:selected].blank?
    @template.battle_type_select_tag(name, **opts)
  end

  def date_field(name, **opts)
    opts[:value] = @template.params[name] if opts[:value].blank?
    super
  end

  def submit(**)
    super @template.translate("buttons.filter"), name: "", **
  end

  def reset(**)
    @template.link_to @template.translate("buttons.reset"), @template.url_for(only_path: true), **
  end
end
