module Buckler
  class LeaguePoint < SimpleDelegator
    def initialize(value)
      super(value.to_i)
    end

    Enums::LEAGUE_THRESHOLD.values.each do |name|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{name}? = name == "#{name}"
      RUBY
    end

    def name
      threshold = Enums::LEAGUE_THRESHOLD.keys.select { |it| self >= it }.max
      Enums::LEAGUE_THRESHOLD[threshold]
    end

    def inspect
      "#<#{self.class} #{to_i}:#{self}>"
    end
  end
end
