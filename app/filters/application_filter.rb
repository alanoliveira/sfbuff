class ApplicationFilter
  def self.filter(relation, params)
    new(relation).filter(params)
  end

  def initialize(relation)
    @relation = relation
  end

  attr_accessor :relation

  def filter(params)
    public_methods(false).inject(@relation) do |rel, name|
      @relation = params[name].present? ?
        public_send(name, params[name]) :
        rel
    end
  end
end
