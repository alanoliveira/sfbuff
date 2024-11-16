require_relative "buckler/railtie"

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
