# frozen_string_literal: true

class BattlelogImporter
  def initialize(**params)
    @battlelog = params[:battlelog]
    @import_condition = params[:import_condition]
  end

  def call
    Battle.transaction do
      @battlelog
        .lazy
        .map { |raw| Parsers::BattlelogParser.parse(raw) }
        .take_while(&@import_condition)
        .reject { |battle| Battle.exists?(replay_id: battle.replay_id) }
        .to_a
        .each(&:save!)
    end
  end
end
