# frozen_string_literal: true

class BattlelogImporter
  def initialize(**params)
    @battlelog = params[:battlelog]
    @import_condition = params[:import_condition]
  end

  def call
    @battlelog
      .lazy
      .map { |raw| Parsers::BattlelogParser.parse(raw) }
      .take_while(&@import_condition)
      .to_a
      .each do |battle|
        battle.save
      rescue ActiveRecord::RecordNotUnique
        # do nothing (the battle was already imported by the opponent)
      end
  end
end
