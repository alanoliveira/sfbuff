require "buckler/railtie" if defined?(Rails)

module Buckler
  class InvalidShortId < ArgumentError; end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
