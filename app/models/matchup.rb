module Matchup
  class << self
    def call(home: Challenger.all, away: Challenger.all)
      Battle.extending(self).tap do |matchup|
        matchup.instance_variable_set(:@home, home)
        matchup.instance_variable_set(:@away, away)
      end
    end

    private

    def respond_to_missing?(...)
      Battle.respond_to?(...) || super
    end

    def method_missing(method_name, ...)
      call.public_send(method_name, ...)
    end
  end

  attr_accessor :home, :away

  def where!(opts, *rest)
    return super if opts.blank?

    home_criteria = opts.delete(:home) if opts.is_a? Hash
    away_criteria = opts.delete(:away) if opts.is_a? Hash
    (opts.present? ? super : self).tap do |it|
      it.home = home.where(home_criteria) if home_criteria
      it.away = away.where(away_criteria) if away_criteria
    end
  end

  def performance
    extending(Performance)
  end

  def results
    @results ||= extending(Results)
      .unscope(:order, :limit, :offset)
      .where(id: records.pluck(:id))
      .to_h
  end

  def index_with_result
    index_with { |b| results[b.id] }
  end

  def with_values
    super | [ { home: }, { away: } ]
  end

  def joins_values
    super.dup.push <<-JOIN.squeeze(" ")
      INNER JOIN "home" ON "home".battle_id = "battles"."id"
      INNER JOIN "away" ON "away".battle_id = "battles"."id"
                       AND "away"."side" = CASE WHEN "home"."side" = 1 THEN 2 ELSE 1 END
    JOIN
  end

  def reset
    @results = nil
    super
  end

  protected

  attr_accessor :home, :away
end
