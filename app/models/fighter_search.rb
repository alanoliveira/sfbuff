class FighterSearch
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Turbo::Broadcastable

  attribute :id, default: -> { SecureRandom.uuid }
  attribute :query
  attribute :result

  validates :query, length: { minimum: 4 }

  def query=(val)
    super(val.strip.downcase)
  end

  def search_now
    assign_attributes(result: search)
    ensure broadcast_render
  end

  def search_later(...)
    FighterSearch::SearchJob.set(...).perform_later(self)
  end

  def to_key
    [ id ]
  end

  def to_param
    id
  end

  def inspect
    "#<#{self.class}: #{attributes}>"
  end

  def ==(other)
    other.is_a?(FighterSearch) && other.id == id
  end

  private

  def search
    FighterSearcher.new(query).search
  end
end
