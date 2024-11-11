module Buckler
  class BattlelogIterator
    include Enumerable

    attr_reader :next_api, :short_id

    def initialize(next_api:, short_id:)
      @next_api = next_api
      @short_id = short_id
    end

    def each(&block)
      # API always returns data from pg 10 when searching for pg > 10
      # this bound prevent infinite loop
      (1..10).each do |page|
        replay_list = next_api.battlelog(short_id, page)
        break if replay_list.empty?

        replay_list.each(&block)
      end
    end
  end
end
