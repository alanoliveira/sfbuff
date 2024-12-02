class BucklerApi::BattlelogIterator
  include Enumerable

  attr_reader :client, :short_id

  def initialize(client, short_id)
    @client = client
    @short_id = short_id
  end

  def each(&block)
    # client always returns data from pg 10 when searching for pg > 10
    # this bound prevent infinite loop
    (1..10).each do |page|
      replay_list = client.battlelog(short_id, page)
      break if replay_list.empty?

      replay_list.each(&block)
    end
  end
end
