require_relative "../../config/environment"


Fighter::Synchronization.where(uuid: nil).find_each.each { it.update(uuid: SecureRandom.uuid) }
