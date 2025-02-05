class BucklerApi::StrategySelector
  attr_reader :strategies

  def initialize
    @strategies = []
    @semaphore = Mutex.new
  end

  def renew
    @current = nil
  end

  def current
    @current || @semaphore.synchronize do
      @current ||= fetch
    end
  end

  private

  def fetch
    strategies.lazy.filter_map(&:call).first
  end
end
