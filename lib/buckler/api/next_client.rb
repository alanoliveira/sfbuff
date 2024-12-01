module Buckler
  module Api
    class NextClient
      attr_reader :next_api

      def initialize(next_api)
        @next_api = next_api
      end

      def battle_list(short_id)
        short_id = ShortId.new(short_id)

        BattlelogIterator.new(next_api:, short_id:)
      end

      def find_fighter_banner(short_id)
        short_id = ShortId.new(short_id)

        next_api.fighterslist(short_id:).first
      end

      def search_fighter_banner(term)
        raise ArgumentError if term.length < 4

        result = next_api.fighterslist(fighter_id: term)
        begin
          short_id_result = find_fighter_banner(term)
          result << short_id_result if short_id_result.present?
        rescue ArgumentError
          # do nothing
        end

        result
      end
    end
  end
end
