class RankedHistory::ExtraStep
  attr_reader :fighter_id, :character_id, :date, :mr, :lp

  delegate :present?, :[], to: :extra_step_data

  def initialize(fighter_id:, character_id:, date:)
    @fighter_id = fighter_id
    @character_id = character_id
    @date = date
  end

  def mr
    extra_step_data["mr"] if present?
  end

  def lp
    extra_step_data["lp"] if present?
  end

  private

  def extra_step_data
    @extra_step_data ||= begin
      if date == Date.today
        extra_step_from_league_info
      else
        extra_step_from_ranked_steps || extra_step_from_league_info
      end || {}
    end
  end

  def extra_step_from_league_info
    CharacterLeagueInfo.where(
      fighter_id:,
      character_id:
    ).take&.as_json
  end

  def extra_step_from_ranked_steps
    RankedHistory::RankedStep.where(
      fighter_id:,
      character_id:,
      played_at: date.end_of_day..
    ).sorted.first&.as_json
  end
end
