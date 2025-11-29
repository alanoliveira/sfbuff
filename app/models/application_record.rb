class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.composed_of_enum(part_id, mapped_field, class_name: nil, array: false)
    class_name ||= part_id.to_s.camelize
    enum_class = class_name.constantize
    composed_of part_id,
      mapping: { mapped_field => :itself },
      class_name:,
      constructor: Proc.new { |val| array ? val.map { enum_class[it] } : enum_class[val] }
  end
end
