class EnumAttribute
  class << self
    include Enumerable

    def names
      @names ||= {}
    end

    def each(...)
      names.keys.map { new _1 }.each(...)
    end

    def [](key)
      key = names.key(key) if String === key
      new(key) unless key.nil?
    end

    def name_for(id)
      names[id] || "#{name}##{id}"
    end
  end

  attr_reader :id
  alias to_i id

  def initialize(id)
    @id = Integer(id)
  end

  def human_name
    I18n.translate(self, scope: [ "buckler", self.class.name.underscore ])
  end

  def to_s
    self.class.name_for(id)
  end

  def ==(other)
    id == other.to_i
  end

  def eql?(other)
    other.is_a?(self.class) && self == other
  end

  def hash
    [ self.class, id ].hash
  end

  def inspect
    "#<#{self.class} #{self}>"
  end
end
