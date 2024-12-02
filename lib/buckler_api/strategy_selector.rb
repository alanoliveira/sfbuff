class BucklerApi::StrategySelector
  attr_accessor :strategies

  def initialize(*strategies)
    @strategies = strategies
    @semaphore = Mutex.new
  end

  def renew
    @current = nil
  end

  def to_s
    current.to_s
  end

  private

  def current
    @semaphore.synchronize do
      @current ||= fetch
    end
  end

  def fetch
    strategies.lazy.map(&:call).find(&:itself)
  end
end
