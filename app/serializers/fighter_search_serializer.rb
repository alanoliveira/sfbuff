class FighterSearchSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize(fighter_search)
    super("id" => fighter_search.id, "query" => fighter_search.query)
  end

  def deserialize(hash)
    FighterSearch.new(id: hash["id"], query: hash["query"])
  end

  private

  def klass
    FighterSearch
  end
end
