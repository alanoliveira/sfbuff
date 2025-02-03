module CharactersHelper
  def character_name(character)
    Character[character].name.titlecase
  end
end
