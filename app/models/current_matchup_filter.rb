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
        Challenger.all.tap do
          _1.where!(short_id: #{name}_short_id) if #{name}_short_id.present?
          _1.where!(character: #{name}_character) if #{name}_character.present?
          _1.where!(control_type: #{name}_control_type) if #{name}_control_type.present?
          _1.where!(master_rating: #{name}_mr_range) if #{name}_mr_range.present?
          _1.where!(league_point: #{name}_lp_range) if #{name}_lp_range.present?
        end
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
    Battle.all.tap do
      _1.where!(battle_type:) if battle_type.present?
      _1.where!(played_at: played_at_range) if played_at_range.present?
    end
  end

  def played_at_range
    from = (parse_date(played_from))&.beginning_of_day
    to = (parse_date(played_to))&.end_of_day
    from..to
  end

  def matchup
    Matchup.new(battle:, home:, away:)
  end

  private

  def parse_date(value)
    Date.parse(value) rescue nil
  end
end
