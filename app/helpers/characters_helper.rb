module CharactersHelper
  def character_name(character)
    t("buckler.characters.#{Character[character].name}")
  end

  def characters_options_for_select
    Character.to_h { [ character_name(it), it.id ] }
  end
end
