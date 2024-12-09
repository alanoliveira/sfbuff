class BucklerApi::StrategySelector
  attr_accessor :strategies

  def initialize(*strategies, eager_load: true)
    @strategies = strategies
    @semaphore = Mutex.new
    current if eager_load
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
