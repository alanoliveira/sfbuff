# frozen_string_literal: true

class PlayersController
  class RankedAction < BaseAction
    PERIOD = { day: 1, week: 2, month: 3 }.freeze

    attribute :character, :integer
    attribute :period, :integer

    attr_accessor :player

    def master_rating_data
      []
    end

    def league_point_data
      []
    end
  end
end
