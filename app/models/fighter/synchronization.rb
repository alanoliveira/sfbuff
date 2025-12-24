class Fighter::Synchronization < ApplicationRecord
  enum :status, %w[ created processing success failure stall ], default: "created"
  attribute :uuid, default: -> { SecureRandom.uuid }
  has_and_belongs_to_many :synchronized_battles, foreign_key: "fighter_synchronization_id", class_name: "Battle", dependent: :delete_all
  belongs_to :fighter

  scope :unfinished, -> { where(status: [ "created", "processing" ]) }

  def finished? = success? || failure? || stall?
  def unfinished? = !finished?

  def process!
    return unless start_processing!
    synchronize_battles!
    synchronize_profile!
    success!
  rescue => error
    self[:error] = error.class.name
    failure!
    raise
  end

  private

  def start_processing!
    created? && with_lock { processing! if created? }
  end

  def synchronize_battles!
    self.synchronized_battles = BattlesSynchronizer.new(fighter).synchronize!
  end

  def synchronize_profile!
    ProfileSynchronizer.new(fighter).synchronize!
  end
end
