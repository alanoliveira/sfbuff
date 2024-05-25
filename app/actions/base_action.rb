# frozen_string_literal: true

class BaseAction
  include ActiveModel::Model
  include ActiveModel::Attributes

  def initialize(params, **opts)
    super(params.permit(self.class.attribute_names))
    opts.each { |k, v| public_send("#{k}=", v) }
  end
end
