# frozen_string_literal: true

module Buckler
  class Api
    class Battlelog
      include Enumerable

      attr_reader :player_sid

      def initialize(client, player_sid)
        @player_sid = player_sid
        @client = client
        @pages_cache = []
      end

      def each(&block)
        # API always returns data from pg 10 when searching for pg > 10
        # this bound prevent infinite loop
        (1..10).each do |page|
          replay_list = page_data(page).fetch('replay_list')
          break if replay_list.empty?

          replay_list.each(&block)
        end
      end

      private

      def page_data(page)
        @pages_cache.fetch(page) do
          data = @client.battlelog(@player_sid, page)
          @pages_cache[page] = data.fetch('pageProps')
        end
      end
    end
  end
end
