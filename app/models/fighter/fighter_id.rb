class Fighter
  FighterId = Data.define(:fighter_id) do
    delegate :to_i, :to_s, to: :fighter_id

    def initialize(fighter_id:)
      super(fighter_id: fighter_id.to_s)
    end

    def valid?
      fighter_id.match? /\d{9,}/
    end
  end
end
