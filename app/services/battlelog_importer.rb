# frozen_string_literal: true

class BattlelogImporter
  def initialize(battlelog)
    @battlelog = battlelog
  end

  def import_while!(&cond)
    Battle.transaction do
      @battlelog
        .lazy
        .map { |raw| Parsers::BattlelogParser.parse(raw) }
        .take_while(&cond)
        .reject { |battle| Battle.exists?(replay_id: battle.replay_id) }
        .to_a
        .each(&:save!)
    end
  end
end
