class BucklerGateway
  include Singleton

  class << self
    delegate_missing_to :instance
  end

  attr_accessor :buckler_connection
end
