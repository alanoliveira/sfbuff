class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.lookup_enum(name, **)
    attribute_name ||= "#{name}_id"

    composed_of name, mapping: { attribute_name => :itself }, constructor: :[], converter: :[], allow_nil: true, **
  end
end
