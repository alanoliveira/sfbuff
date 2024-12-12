class MatchupChart
  include ActiveModel::API
  include Enumerable

  attr_reader :matchup

  delegate :cache_version, to: :matchup
  delegate :each, to: :to_a

  def initialize(matchup)
    @matchup = matchup
  end

  def sum
    to_a.filter_map { _1[:score] }.reduce(Score.zero, &:+)
  end

  def load
    @data ||= begin
      Character.to_a.product(ControlType.to_a).map do |character, control_type|
        score = relation.find { |group, _| [ character, control_type ] == group.values_at("character", "control_type") }&.second
        { character:, control_type:, score: }
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

  def to_key
    [ query_signature ]
  end

  private

  def query_signature
    ActiveSupport::Digest.hexdigest(relation.to_sql)
  end

  def relation
    matchup
      .performance
      .group(away: [ :character, :control_type ])
      .select(away: [ :character, :control_type ])
  end
end
