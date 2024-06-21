# frozen_string_literal: true

module BucklerErrorClassifiable
  extend ActiveSupport::Concern

  def resolve_buckler_error_kind(error)
    case error
    when PlayerSynchronizer::PlayerNotFoundError then 'player_not_found'
    when ArgumentError then 'argument_error'
    when Buckler::Client::ServerUnderMaintenance then 'server_under_maintenance'
    else 'generic'
    end
  end
end
