class CurrentMatchupFilter < ActiveSupport::CurrentAttributes
  attribute :battle_type
  attribute :played_from
  attribute :played_to

  [ "home", "away" ].each do |name|
    class_eval <<~RUBY, __FILE__, __LINE__ + 1
      attribute :"#{name}_short_id"
      attribute :"#{name}_character"
      attribute :"#{name}_control_type"
      attribute :"#{name}_mr_from"
      attribute :"#{name}_mr_to"
      attribute :"#{name}_lp_from"
      attribute :"#{name}_lp_to"

      def #{name}
        {
          short_id: #{name}_short_id,
          character: #{name}_character,
          control_type: #{name}_control_type,
          master_rating: #{name}_mr_range,
          league_point: #{name}_lp_range,
        }.compact_blank
      end

      def #{name}_mr_range#{' '}
        from = #{name}_mr_from.presence
        to = #{name}_mr_to.presence
        return unless [from, to].any?
        from..to
      end

      def #{name}_lp_range#{' '}
        from = #{name}_lp_from.presence
        to = #{name}_lp_to.presence
        return unless [from, to].any?
        from..to
      end
    RUBY
  end

  def battle
    { battle_type:, played_at: played_at_range }.compact_blank
  end

  def played_at_range
    from = (parse_date(played_from))&.beginning_of_day
    to = (parse_date(played_to))&.end_of_day
    from..to
  end

  def matchup
    Matchup.new.tap do
      _1.where_battle!(battle) if battle.present?
      _1.where_home!(home) if home.present?
      _1.where_away!(away) if away.present?
    end
  end

  private

  def parse_date(value)
    Date.parse(value) rescue nil
  end
end
