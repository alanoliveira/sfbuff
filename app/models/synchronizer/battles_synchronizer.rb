class Synchronizer::BattlesSynchronizer
  attr_reader :battles

  def initialize(battles:)
    @battles = battles
  end

  def synchronize!
    battles.each do |battle|
      battle.save!
    rescue ActiveRecord::RecordNotUnique
      # ignore, the battle was already imported by the opponent
    end
  end
end
