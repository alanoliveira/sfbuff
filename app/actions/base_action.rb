# frozen_string_literal: true

class BaseAction
  include ActiveModel::Model
  include ActiveModel::Attributes

  def initialize(params, **defaults)
    attrs = params
            .fetch(model_name.param_key, {})
            .permit(self.class.attribute_names)
            .with_defaults(defaults)
    super(attrs)
  end
end
