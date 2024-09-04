class BaseForm
  include ActiveModel::API
  include ActiveModel::Attributes

  def fill(params)
    params = params.fetch(model_name.param_key) if model_name.param_key.present?
    assign_attributes params.permit(attribute_names).with_defaults(default_attributes)
    self
  end

  private

  def default_attributes
    {}
  end
end
