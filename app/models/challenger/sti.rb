module Challenger::Sti
  extend ActiveSupport::Concern

  included do
    self.inheritance_column = :side
  end

  class_methods do
    def sti_class_for(side)
      case side
      when 1 then Challengers::P1
      when 2 then Challengers::P2
      end
    end

    def sti_name
      case name
      when "Challengers::P1" then 1
      when "Challengers::P2" then 2
      end
    end
  end

  def p1?
    is_a? Challengers::P1
  end

  def p2?
    is_a? Challengers::P2
  end
end
