class UpdateChallengersMrVariation < ActiveRecord::Migration[7.1]
  def up
    Battle.ranked.each do |b|
      next if b.raw_battle.nil?

      parsed = Parsers::BattlelogParser.parse(b.raw_battle.data)
      b.p1.update(mr_variation: parsed.p1.mr_variation)
      b.p2.update(mr_variation: parsed.p2.mr_variation)
    end
  end
end
