class RankedHistory
  include ActiveModel::API
  include Enumerable

  attr_reader :short_id, :character, :date_range

  delegate :each, to: :to_a

  def initialize(short_id, character, date_range: nil)
    @short_id = short_id
    @character = Character.new(character)
    @date_range = date_range
  end

  def load
    @data ||= begin
      relation.map do |challenger|
        battle = challenger.battle
        {
          replay_id: battle.replay_id,
          played_at: battle.played_at,
          master_rating: challenger.master_rating,
          league_point: challenger.league_point,
          mr_variation: challenger.master_rating_variation,
          lp_variation: challenger.league_point_variation
        }
      end
    end
  end
  alias to_a load

  def loaded?
    @data.present?
  end

  def cache_key
    "#{model_name.cache_key}/query-#{query_signature}"
  end

  def cache_version
    challenger_rel.order(:created_at).last.try(:cache_version)
  end

  def to_key
    [ query_signature ]
  end

  private

  def query_signature
    ActiveSupport::Digest.hexdigest(relation.to_sql)
  end

  def relation
    challenger_rel.joins(:battle).includes(:battle).merge(battle_rel)
      .select(
        :battle_id, :master_rating, :league_point, :ranked_variation,
        battles: [ :id, :replay_id, :played_at ]
      )
  end

  def battle_rel
    Battle
      .ranked
      .tap { _1.where!(played_at: date_range) if date_range.present? }
      .order(:played_at)
  end

  def challenger_rel
    Challenger.where(short_id:, character:)
  end
end
