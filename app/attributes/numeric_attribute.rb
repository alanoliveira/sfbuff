class NumericAttribute
  extend Forwardable
  include Comparable

  def_delegators :@value, :to_i, :to_s, :to_json, :as_json, :coerce, :positive?, :negative?, :zero?, :===

  def initialize(value)
    @value = value.to_i
  end

  %i[+ - * / ** %].each do |name|
    define_method name do |other|
      self.class.new(to_i.public_send(name, other.to_i))
    end
  end

  def <=>(other)
    to_i <=> other.to_i
  end

  def inspect
    "#<#{self.class} #{self}>"
  end
end
