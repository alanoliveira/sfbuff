class ShortId
  extend Forwardable

  def_delegators :@short_id, :to_i, :to_s, :to_json, :as_json

  def initialize(value)
    @short_id = Integer(value)
    raise ArgumentError, "#{value} is not a valid short id" if @short_id < 100_000_000
  end

  def ==(other)
    return false unless other.respond_to? :to_i

    to_i == other.to_i
  end

  def inspect
    "#<#{self.class} #{self}>"
  end
end
