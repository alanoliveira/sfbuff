class Fighter::Synchronizer::BattlesSynchronizer
  attr_reader :fighter

  def initialize(fighter)
    @fighter = fighter
  end

  def synchronize
    new_battles = fetch_new_battles
    return if new_battles.empty?

    synchronized_battles_count = 0
    new_battles.each do |battle|
      battle.save!
      synchronized_battles_count += 1
    rescue ActiveRecord::RecordNotUnique
      # do nothing, it already was imported by the opponent
    end

    fighter.last_synchronized_replay_id = new_battles[0].replay_id
    synchronized_battles_count
  end

  private

  def fetch_new_battles
    (1..10).lazy
      .map { BucklerGateway.fetch_fighter_battles(fighter.id, it) }
      .take_while(&:present?)
      .flat_map(&:itself)
      .take_while { it.replay_id != fighter.last_synchronized_replay_id }
      .to_a
  end
end
